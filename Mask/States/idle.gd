extends State


func physics_update(_delta: float) -> void:
	owner.update_move_dir()

	owner.velocity = owner.direction * owner.move_speed

func  update(_delta: float) -> void:
	Debugger.printui("owner.velocity: "+str(owner.velocity))
	if Input.is_action_just_pressed("attack"):
		owner.sword.attack()
