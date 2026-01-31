extends State

func physics_update(delta: float) -> void:
	owner.move(delta)

func  update(_delta: float) -> void:
	owner.weapon.input_handle()

	match owner.direction:
		Vector2(1, 1):
			owner.anim_player.play("fighter_dright")
		Vector2(-1, 1):
			owner.anim_player.play("fighter_dleft")
		Vector2(1, -1):
			owner.anim_player.play("fighter_uright")
		Vector2(-1, -1):
			owner.anim_player.play("fighter_uleft")

	if owner.velocity == Vector2.ZERO:
		finished.emit("idle")
