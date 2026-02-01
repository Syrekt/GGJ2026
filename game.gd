class_name Game extends Node

var mask : Mask
enum MAPS { NONE, VILLAGE, RUINS, FOREST }
var previous_map : MAPS = MAPS.NONE

static func get_singleton() -> Game:
	return (Game as Script).get_meta(&"singleton") as Game

func _ready() -> void:
	get_script().set_meta(&"singleton", self)

	add_child(load("res://Map/village_scene.tscn").instantiate())

func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed() && event is InputEventKey:
		match event.keycode:
			KEY_R:
				if OS.is_debug_build():
					restart_game()

func restart_game() -> void:
	for child in get_children():
		if child is Node2D:
			child.queue_free()

	add_child(load("res://main_scene.tscn").instantiate())

func switch_scene(from_map:MAPS,target_scene:PackedScene) -> void:
	print("Switching to scene: " + str(target_scene))
	for child in get_children():
		if child is Node2D:
			child.queue_free()
	get_tree().current_scene.add_child(target_scene.instantiate())
