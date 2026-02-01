extends Area2D

@export var target_scene : PackedScene
@export var previous_map : Game.MAPS


func _on_body_entered(body: Node2D) -> void:
	Game.get_singleton().switch_scene(previous_map, target_scene)
