extends State

func enter(previous_state_path: String, data := {}) -> void:
	owner.sprite.play("idle")
	owner.on_chase = false
