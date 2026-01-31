extends State


func physics_update(delta: float) -> void:
	owner.update_move_dir()

	owner.velocity = owner.direction * owner.move_speed * delta

func  update(_delta: float) -> void:
	owner.weapon.input_handle()
