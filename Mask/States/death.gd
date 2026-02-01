extends State

var timer : Timer

func enter(previous_state_path: String, data := {}) -> void:
	owner.weapon.queue_free()
	owner.weapon_charge.value = 0
	match owner.direction:
		Vector2(1, 1):
			owner.anim_player.play(owner.class_string + "_death_dright")
		Vector2(-1, 1):
			owner.anim_player.play(owner.class_string + "_death_dleft")
		Vector2(1, -1):
			owner.anim_player.play(owner.class_string + "_death_uright")
		Vector2(-1, -1):
			owner.anim_player.play(owner.class_string + "_death_uleft")

	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_on_death_timer_timeout)
	timer.one_shot = true
	timer.start(2.0)

func exit() -> void:
	timer.timeout.disconnect(_on_death_timer_timeout)
	timer.queue_free()

func _on_death_timer_timeout() -> void:
	owner.restart_menu.show()
