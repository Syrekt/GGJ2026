extends State

func enter(previous_state_path: String, data := {}) -> void:
	owner.velocity.x = 0.0

	if owner.direction.x == 1:
		owner.anim_player.play(owner.class_string + "_idle_right")
	else:
		owner.anim_player.play(owner.class_string + "_idle_left")

func physics_update(delta: float) -> void:
	owner.move(delta)

	if owner.velocity != Vector2.ZERO:
		finished.emit("walk")

func  update(_delta: float) -> void:
	owner.weapon.input_handle()
