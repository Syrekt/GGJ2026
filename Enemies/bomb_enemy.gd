class_name BombEnemy extends Enemy


func _ready() -> void:
	on_throw.connect(_on_throw)
	$BombTimer.timeout.connect(_on_bomb_timer_timeout)

func _on_throw() -> void:
	$BombTimer.start()
	var tween = create_tween().bind_node(self).set_loops(-1)
	tween.tween_property(sprite.material, "shader_parameter/tint_color", Color(1, 0, 0, 1), 0.2)
	tween.tween_property(sprite.material, "shader_parameter/tint_color", Color(1, 0, 0, 0), 0.2)

func _on_bomb_timer_timeout() -> void:
	exploding = true
	sprite.play("dead")
	sprite.animation_finished.connect(queue_free)
	$ExplosionSFX.play()


	for body in $ExplosionRange.get_overlapping_bodies():
		if body == self: continue
		body.take_damage(self)
