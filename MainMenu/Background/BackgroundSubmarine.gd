extends Path3D

@export var progress_speed = 1.
@export var fan_rotation_speed = 10.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    $PathFollow3D.progress += progress_speed * delta
    $PathFollow3D/Submarine/Fan.rotate_x(delta * fan_rotation_speed)
