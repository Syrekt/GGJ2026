class_name Game extends Node

var mask : Mask
enum MAPS { NONE, VILLAGE, RUINS, FOREST }
var previous_map : MAPS = MAPS.NONE
@onready var canvas_modulate: CanvasModulate = $CanvasModulate

var canvas_tween : Tween

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
		if child is Node2D && child != canvas_modulate:
			child.queue_free()

	add_child(load("res://main_scene.tscn").instantiate())

func switch_scene(from_map:MAPS,target_scene:PackedScene) -> void:
	previous_map = from_map
	call_deferred("_do_scene_switch", target_scene)

	if canvas_tween: canvas_tween.kill()

	canvas_tween = create_tween().bind_node(self)
	canvas_modulate.color = Color(0, 0, 0, 1)

	canvas_tween.tween_property(canvas_modulate, "color", Color(1, 1, 1, 1), 1.0)
	

func _do_scene_switch(target_scene: PackedScene) -> void:
	for child in get_children():
		if child is Node2D && child != canvas_modulate:
			child.queue_free()

	var new_scene := target_scene.instantiate()
	get_tree().current_scene.add_child(new_scene)
