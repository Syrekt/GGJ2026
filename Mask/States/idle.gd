extends State


func physics_update(delta: float) -> void:
	owner.update_move_dir()

	owner.velocity = owner.direction * owner.move_speed * delta

func  update(_delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		owner.sword.attack()
