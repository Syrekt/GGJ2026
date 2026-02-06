extends Area2D

@export var target_scene : String
@export var previous_map : Game.MAPS

var active := false

func _ready() -> void:
	get_tree().create_timer(1.0).timeout.connect(_on_timer_timeout)


func _on_timer_timeout() -> void:
	active = true

func _physics_process(delta: float) -> void:
	if !active: return

	if has_overlapping_bodies():
		var game = Game.get_singleton()
		game.player_health = game.mask.health.value
		game.switch_scene(previous_map, load(target_scene))
