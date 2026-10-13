extends CharacterBody3D

@export var fan_rotation_speed: float = 2.0
@export var player_speed: float = 10.0
@export var player_sensitivity: float = 5.0

func _ready() -> void:
	velocity.z = -player_speed

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, -input_dir.y, 0)).normalized()
	if direction:
		velocity.x = direction.x * player_sensitivity
		velocity.y = direction.y * player_sensitivity
	else:
		velocity.x = move_toward(velocity.x, 0, player_sensitivity)
		velocity.y = move_toward(velocity.y, 0, player_sensitivity)
	
	move_and_slide()
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		_on_collision(collision)

func _on_collision(collision: KinematicCollision3D):
	var collider: Node = collision.get_collider() as Node
	if collider.is_in_group("obstacle"):
		queue_free()

func _process(delta: float) -> void:
	$Submarine/Fan.rotate_x(delta * fan_rotation_speed)
