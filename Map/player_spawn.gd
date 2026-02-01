extends Node2D

@export var previous_map : Game.MAPS = Game.MAPS.NONE
const MASK := preload("res://Mask/mask.tscn")

func _ready() -> void:
	Game.get_singleton().scene_ready.connect(_on_scene_ready)

func _on_scene_ready() -> void:
	print("previous_map: "+str(previous_map))
	var game = Game.get_singleton()
	print("game.previous_map: "+str(game.previous_map));
	if game.previous_map != previous_map:
		queue_free()
		print("Destroy player spawn")
	else:
		var mask = MASK.instantiate()
		mask.global_position = global_position


		var order_node = get_tree().current_scene.find_child("Order", true, false)
		if order_node:
			order_node.add_child(mask)
		else:
			printerr("Can't find order")
			mask.queue_free()

func spawn() -> void:
	var mask = MASK.instantiate()
	mask.global_position = global_position

	var order_node = get_tree().current_scene.find_child("Order", true, false)
	if order_node:
		order_node.add_child(mask)
	else:
		mask.queue_free()
