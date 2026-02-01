extends State

func enter(previous_state_path: String, data := {}) -> void:
	owner.sprite.play("idle")
	owner.on_chase = false

func physics_update(_delta: float) -> void:
	if owner.detection_area.has_overlapping_bodies():
		owner.on_chase = true
		finished.emit("move")
