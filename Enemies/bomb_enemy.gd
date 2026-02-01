extends Enemy



func _ready() -> void:
	on_throw.connect(_on_throw)
	$BombTimer.timeout.connect(_on_bomb_timer_timeout)

func _on_throw() -> void:
	$BombTimer.start()
	var tween = create_tween().bind_node(self).set_loops(-1)
	tween.tween_property(sprite.material, "shader_parameter/tint_color", Color(1, 0, 0, 1), 0.2)
	tween.tween_property(sprite.material, "shader_parameter/tint_color", Color(1, 0, 0, 0), 0.2)

func _on_bomb_timer_timeout() -> void:
	print("explode")
	queue_free()
