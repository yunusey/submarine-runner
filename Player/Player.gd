extends CharacterBody3D

@export var fan_rotation_speed: float = 2.0
@export var player_speed: float = 10.0
@export var player_sensitivity: float = 5.0
@export var curve: Curve3D

signal died

var local_position: Vector2 = Vector2.ZERO
var progress: float = 0

func _ready() -> void:
    pass

func _physics_process(delta: float) -> void:
    var input_dir := Input.get_vector("move_left", "move_right", "move_down", "move_up").normalized()
    
    var local_velocity: Vector2
    if input_dir:
        local_velocity.x = input_dir.x * player_sensitivity
        local_velocity.y = input_dir.y * player_sensitivity
    else:
        local_velocity.x = move_toward(velocity.x, 0, player_sensitivity)
        local_velocity.y = move_toward(velocity.y, 0, player_sensitivity)
    
    local_position = (local_position + local_velocity * delta).clamp(
        Vector2(-1, -1),
        Vector2(1, 1)
    )
    progress = fmod(progress + delta * player_speed, curve.get_baked_length())
    var curve_transform = curve.sample_baked_with_rotation(progress)
    rotation = curve_transform.basis.get_euler()
    
    var current_position = position
    var target_position = curve_transform * Vector3(local_position.x, local_position.y, 0)
    var motion = target_position - current_position

    var collision = move_and_collide(motion)
    _on_collision(collision)


# NOTE: To make sure that died is emitted one time--to avoid race conditions
var is_dead: bool = false
func _on_collision(collision: KinematicCollision3D):
    if is_dead or not collision:
        return

    var collider: Node = collision.get_collider() as Node
    if collider.is_in_group("obstacle"):
        is_dead = true
        died.emit()


func _process(delta: float) -> void:
    $Submarine/Fan.rotate_x(delta * fan_rotation_speed)
