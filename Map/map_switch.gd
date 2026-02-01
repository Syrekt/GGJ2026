extends Area2D

@export var target_scene : String
@export var previous_map : Game.MAPS


func _on_body_entered(body: Node2D) -> void:
	var game = Game.get_singleton()
	game.player_health = body.health.value
	game.switch_scene(previous_map, load(target_scene))

