extends Node

func _ready() -> void:
	add_child(load("res://main_scene.tscn").instantiate())

func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed() && event is InputEventKey:
		match event.keycode:
			KEY_R:
				restart_game()

func restart_game() -> void:
	get_child(0).queue_free()

	add_child(load("res://main_scene.tscn").instantiate())
