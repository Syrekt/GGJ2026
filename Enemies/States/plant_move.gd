extends State

var target_position : Vector2

func enter(previous_state_path: String, data := {}) -> void:
	owner.sprite.play("move")
	owner.on_chase = false

	target_position = owner.global_position + Vector2.from_angle(randf_range(-PI, PI)) * 64

func exit() -> void:
	owner.velocity = Vector2.ZERO


func physics_update(_delta: float) -> void:
	owner.velocity = owner.global_position.direction_to(target_position) * owner.move_speed

	if owner.global_position.distance_to(target_position) < Vector2(4, 4):
		finished.emit("shoot")
