extends StaticBody3D
class_name Obstacle

@onready var material: StandardMaterial3D = $MeshInstance3D.get_active_material(0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func fade_in() -> void:
    material.albedo_color.a = 1.0

func fade_out() -> void:
    material.albedo_color.a = 0.3
