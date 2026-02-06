class_name Game extends Node

var mask : Mask
enum MAPS { NONE, VILLAGE, RUINS, FOREST }
var previous_map : MAPS = MAPS.NONE
@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var bgm: FmodEventEmitter2D = $BGM

var player_health : int
var brawler_unlocked := false
var ranger_unlocked := false

var canvas_tween : Tween

signal scene_ready

static func get_singleton() -> Game:
	return (Game as Script).get_meta(&"singleton") as Game

func _ready() -> void:
	get_script().set_meta(&"singleton", self)

	add_child(load("res://Map/village_scene.tscn").instantiate())

	scene_ready.emit()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed() && event is InputEventKey:
		match event.keycode:
			KEY_R:
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
	print_stack()
	

func _do_scene_switch(target_scene: PackedScene) -> void:
	for child in get_children():
		if child is Node2D && child != canvas_modulate && child != bgm:
			child.queue_free()

	var new_scene := target_scene.instantiate()
	get_tree().current_scene.add_child(new_scene)

	await get_tree().process_frame

	scene_ready.emit()
