extends Control


func _ready() -> void:
    pass # Replace with function body.

func _process(delta: float) -> void:
    if Input.is_action_pressed("start_game"):
        _on_play_button_pressed()


func _on_play_button_pressed() -> void:
    get_tree().change_scene_to_file("res://Main/Main.tscn")
