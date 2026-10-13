extends Node3D

var obstacle_scene = preload("res://Obstacle/Obstacle.tscn")

const SEGMENT_LENGTH = 10
const PADDING = 20
var POSITIONS = [
	Vector2(0, 0), Vector2(0, 1), Vector2(0, 2),
	Vector2(1, 0), Vector2(1, 1), Vector2(1, 2),
	Vector2(2, 0), Vector2(2, 1), Vector2(2, 2),
]
const NUM_OBSTACLES = 4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var length = $Tunnel.scale.z
	var size = $Tunnel.scale.x / 3
	var num_segments = (length - PADDING) / SEGMENT_LENGTH
	for i in range(num_segments):
		var z_pos = PADDING + i * SEGMENT_LENGTH
		POSITIONS.shuffle()
		for j in range(NUM_OBSTACLES):
			var local_pos = POSITIONS[j]
			var global_pos = size * local_pos + Vector2(size / 2, size / 2)
			var obstacle = obstacle_scene.instantiate()
			obstacle.position = Vector3(global_pos.x, global_pos.y, -z_pos)
			$Obstacles.add_child(obstacle)
		
		var light = OmniLight3D.new()
		light.position = Vector3(
			$Tunnel.scale.x / 2,
			$Tunnel.scale.y / 2,
			-z_pos + PADDING / 2
		)
		$Lights.add_child(light)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	return
