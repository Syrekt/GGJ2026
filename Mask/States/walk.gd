extends State

func physics_update(delta: float) -> void:
	owner.move(delta)

func  update(_delta: float) -> void:
	owner.weapon.input_handle()

	match owner.direction:
		Vector2(1, 1):
			owner.anim_player.play(owner.class_string + "_dright")
		Vector2(-1, 1):
			owner.anim_player.play(owner.class_string + "_dleft")
		Vector2(1, -1):
			owner.anim_player.play(owner.class_string + "_uright")
		Vector2(-1, -1):
			owner.anim_player.play(owner.class_string + "_uleft")

	if owner.velocity == Vector2.ZERO:
		finished.emit("idle")

	if Input.is_action_just_pressed("dodge"):
		if owner.mask_class == owner.CLASSES.RANGER:
			finished.emit("dodge")
