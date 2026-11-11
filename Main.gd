extends Node3D

const OBSTACLE_COLLISION_MASK = (1 << (3 - 1))
var last_blocker = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    var new_blocker = null
    var raycast_query := PhysicsRayQueryParameters3D.create(
        $Camera.global_position,
        $Player.global_position,
        OBSTACLE_COLLISION_MASK
    )
    var result := get_world_3d().direct_space_state.intersect_ray(raycast_query)
    if result:
        var collider = result["collider"]
        new_blocker = collider
        if new_blocker is Obstacle:
            new_blocker.fade_out()
    if last_blocker != new_blocker:
        if last_blocker is Obstacle:
            last_blocker.fade_in()
        last_blocker = new_blocker


func _on_player_died() -> void:
    get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")
