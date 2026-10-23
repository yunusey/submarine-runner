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

const tunnel_segment = preload("res://Tunnel/TunnelSegment.tscn")

func _ready() -> void:
    update_mesh()
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func update_mesh():
    if $Path3D == null:
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

    var vertices := PackedVector3Array()
    var normals := PackedVector3Array()
    var quad_helper := func (res):
        vertices.append_array(res["vertices"])
        normals.append_array(res["normals"])
    
    for i in range(count):
        var progress_a = i * segment_length
        var progress_b = (i + 1) * segment_length
        var transform_a = curve.sample_baked_with_rotation(progress_a)
        var transform_b = curve.sample_baked_with_rotation(progress_b)
        var transform_a_r = Transform3D(transform_a.basis, Vector3.ZERO)
        var transform_b_r = Transform3D(transform_b.basis, Vector3.ZERO)

        # Right face
        quad_helper.call(_create_quad(
            transform_a * top_right, transform_b * top_right,
            transform_b * bottom_right, transform_a * bottom_right,
            transform_a_r * Vector3.LEFT, transform_b_r * Vector3.LEFT,
            transform_b_r * Vector3.LEFT, transform_a_r * Vector3.LEFT
        ))
        # Left face
        quad_helper.call(_create_quad(
            transform_a * top_left, transform_a * bottom_left,
            transform_b * bottom_left, transform_b * top_left,
            transform_a_r * Vector3.RIGHT, transform_a_r * Vector3.RIGHT,
            transform_b_r * Vector3.RIGHT, transform_b_r * Vector3.RIGHT
        ))
        # Top face
        quad_helper.call(_create_quad(
            transform_a * top_right, transform_a * top_left,
            transform_b * top_left, transform_b * top_right,
            transform_a_r * Vector3.DOWN, transform_a_r * Vector3.DOWN,
            transform_b_r * Vector3.DOWN, transform_b_r * Vector3.DOWN
        ))
        # Bottom face
        quad_helper.call(_create_quad(
            transform_b * bottom_right, transform_b * bottom_left,
            transform_a * bottom_left, transform_a * bottom_right,
            transform_b_r * Vector3.UP, transform_b_r * Vector3.UP,
            transform_a_r * Vector3.UP, transform_a_r * Vector3.UP
        ))
    
    var array_mesh = ArrayMesh.new()
    var arrays = []
    arrays.resize(Mesh.ARRAY_MAX)
    arrays[Mesh.ARRAY_VERTEX] = vertices
    arrays[Mesh.ARRAY_NORMAL] = normals
    array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
    $MeshInstance3D.mesh = array_mesh

# a: top-right
# b: top-left
# c: bottom-left
# d: bottom-right
# NOTE: Godot uses clockwise winding order... I found about this after my
# legendary battle with the engine :D
func _create_quad(
    a: Vector3, b: Vector3, c: Vector3, d: Vector3,
    na: Vector3, nb: Vector3, nc: Vector3, nd: Vector3
):
    return {
        "vertices": [
            c, b, a,
            a, d, c
        ],
        "normals": [
            nc, nb, na,
            na, nd, nc
        ]
    }
