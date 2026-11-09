@tool
extends Node3D

@export var segment_length = 1.0:
    set(new_length):
        segment_length = new_length
        update_mesh()


@export var tunnel_size = 3.0:
    set(new_tunnel_size):
        tunnel_size = new_tunnel_size
        update_mesh()

func _ready() -> void:
    update_mesh()


func _process(delta: float) -> void:
    pass

func update_mesh():
    if not has_node("Path3D"):
        return

    var curve: Curve3D = $Path3D.curve
    var length = curve.get_baked_length()
    var count = int(length / segment_length)
    for child in $Instances.get_children():
        child.queue_free()
    
    var offset = tunnel_size / 2.
    var top_left := Vector3(-offset, offset, 0)
    var top_right := Vector3(offset, offset, 0)
    var bottom_left := Vector3(-offset, -offset, 0)
    var bottom_right := Vector3(offset, -offset, 0)

    var st := SurfaceTool.new()
    st.begin(Mesh.PRIMITIVE_TRIANGLES)

    var quad_helper := func (res):
        # vertices.append_array(res["vertices"])
        # normals.append_array(res["normals"])
        # uvs.append_array(res["uvs"])
        for i in range(6):
            st.set_normal(res["normals"][i])
            st.set_uv(res["uvs"][i])
            st.add_vertex(res["vertices"][i])
    
    var connect_back: bool = curve.closed
    for i in range(count):
        var progress_a = i * segment_length
        var progress_b = (i + 1) * segment_length
        if i == count - 1:
            if connect_back:
                progress_b = 0
            else:
                progress_b = length

        var transform_a = curve.sample_baked_with_rotation(progress_a)
        var transform_b = curve.sample_baked_with_rotation(progress_b)
        var transform_a_r = Transform3D(transform_a.basis, Vector3.ZERO)
        var transform_b_r = Transform3D(transform_b.basis, Vector3.ZERO)

        var progress_a_ratio = float(i) / count
        var progress_b_ratio = min(float(i + 1) / count, 1)

        # Right face
        quad_helper.call(_create_quad(
            transform_a * top_right, transform_b * top_right,
            transform_b * bottom_right, transform_a * bottom_right,
            transform_a_r * Vector3.LEFT, transform_b_r * Vector3.LEFT,
            transform_b_r * Vector3.LEFT, transform_a_r * Vector3.LEFT,
            Vector2(tunnel_size, progress_a), Vector2(tunnel_size, progress_b),
            Vector2(0, progress_b), Vector2(0, progress_a),
        ))
        # Left face
        quad_helper.call(_create_quad(
            transform_a * top_left, transform_a * bottom_left,
            transform_b * bottom_left, transform_b * top_left,
            transform_a_r * Vector3.RIGHT, transform_a_r * Vector3.RIGHT,
            transform_b_r * Vector3.RIGHT, transform_b_r * Vector3.RIGHT,
            Vector2(0, progress_a), Vector2(tunnel_size, progress_a),
            Vector2(tunnel_size, progress_b), Vector2(0, progress_b),
        ))
        # Top face
        quad_helper.call(_create_quad(
            transform_a * top_right, transform_a * top_left,
            transform_b * top_left, transform_b * top_right,
            transform_a_r * Vector3.DOWN, transform_a_r * Vector3.DOWN,
            transform_b_r * Vector3.DOWN, transform_b_r * Vector3.DOWN,
            Vector2(tunnel_size, progress_a), Vector2(0, progress_a),
            Vector2(0, progress_b), Vector2(tunnel_size, progress_b),
        ))
        # Bottom face
        quad_helper.call(_create_quad(
            transform_b * bottom_right, transform_b * bottom_left,
            transform_a * bottom_left, transform_a * bottom_right,
            transform_b_r * Vector3.UP, transform_b_r * Vector3.UP,
            transform_a_r * Vector3.UP, transform_a_r * Vector3.UP,
            Vector2(tunnel_size, progress_b), Vector2(0, progress_b),
            Vector2(0, progress_a), Vector2(tunnel_size, progress_a),
        ))
    
    st.generate_normals()
    st.generate_tangents()
    $MeshInstance3D.mesh = st.commit()

# a: top-right
# b: top-left
# c: bottom-left
# d: bottom-right
# NOTE: Godot uses clockwise winding order... I found about this after my
# legendary battle with the engine :D
func _create_quad(
    a: Vector3, b: Vector3, c: Vector3, d: Vector3,
    na: Vector3, nb: Vector3, nc: Vector3, nd: Vector3,
    uva: Vector2, uvb: Vector2, uvc: Vector2, uvd: Vector2
):
    return {
        "vertices": [
            c, b, a,
            a, d, c
        ],
        "normals": [
            nc, nb, na,
            na, nd, nc
        ],
        "uvs": [
            uvc, uvb, uva,
            uva, uvd, uvc
        ]
    }
