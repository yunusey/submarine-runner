extends Camera3D

signal blocking

@export_range(0.0, 100.0, 0.1) var follow_by: float = 5.0
@export var player: Node3D
@export var curve: Curve3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    var progress: float = player.progress
    var camera_progress: float = fmod(
        progress - follow_by + curve.get_baked_length(),
        curve.get_baked_length()
    )
    position = curve.sample_baked(camera_progress)
    rotation = curve.sample_baked_with_rotation(camera_progress).basis.get_euler()

    #look_at(player.position)
