extends Node2D

@export var previous_map : Game.MAPS = Game.MAPS.NONE
const MASK := preload("res://Mask/mask.tscn")

func _ready() -> void:
	var game = Game.get_singleton()
	if game.previous_map != previous_map:
		queue_free()
	else:
		var mask = MASK.instantiate()
		mask.global_position = global_position
		get_tree().current_scene.add_child(mask)
