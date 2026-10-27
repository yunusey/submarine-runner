@tool
extends Node3D

var obstacle_scene = preload("res://Obstacle/Obstacle.tscn")

@export_range(0, 100, 0.01, "hide_slider") var segment_length: float = 2:
    set(new_segment_length):
        segment_length = new_segment_length
        update_map()
@export_range(0, 100, 0.01, "hide_slider") var padding_length: float = 2:
    set(new_padding_length):
        padding_length = new_padding_length
        update_map()
@export_range(0, 9) var num_obstacles: int = 3:
    set(new_num_obstacles):
        num_obstacles = new_num_obstacles
        update_map()

var POSITIONS = [
    Vector2(-1, -1), Vector2(-1, 0), Vector2(-1, 1),
    Vector2(0, -1), Vector2(0, 0), Vector2(0, 1),
    Vector2(1, -1), Vector2(1, 0), Vector2(1, 1),
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    update_map()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    return

func update_map():
    if $Tunnel == null:
        return
    var curve: Curve3D = $Tunnel/Path3D.curve
    var length = curve.get_baked_length()
    var num_segments = (length - padding_length) / segment_length
    var tunnel_size: float = $Tunnel.tunnel_size
    var size := (tunnel_size / 3.)
    for child in $Obstacles.get_children():
        child.queue_free()
    for child in $Lights.get_children():
        child.queue_free()
    
    for i in range(num_segments):
        var curve_pos = padding_length + i * segment_length
        var curve_transform := curve.sample_baked_with_rotation(curve_pos)
        POSITIONS.shuffle()
        for j in range(num_obstacles):
            var local_pos: Vector2 = POSITIONS[j]
            var scaled_pos: Vector2 = size * local_pos
            var obstacle = obstacle_scene.instantiate()
            obstacle.position = curve_transform * Vector3(scaled_pos.x, scaled_pos.y, 0)
            $Obstacles.add_child(obstacle)

        var light = OmniLight3D.new()
        light.position = curve.sample_baked(curve_pos)
        $Lights.add_child(light)
