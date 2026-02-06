extends State

var target_position : Vector2

func enter(previous_state_path: String, data := {}) -> void:
	owner.sprite.play("move")
	owner.on_chase = false

	var mask = Game.get_singleton().mask
	var angle = mask.global_position.angle_to_point(owner.global_position)
	target_position = owner.global_position + Vector2.from_angle(angle) * 64

	get_tree().create_timer(1.0).timeout.connect(_on_timer_timeout)


func exit() -> void:
	owner.velocity = Vector2.ZERO


func physics_update(_delta: float) -> void:
	owner.velocity = owner.global_position.direction_to(target_position) * owner.move_speed * _delta


func _on_timer_timeout() -> void:
	if owner.detection_area.has_overlapping_bodies():
		print("Player detected, keep moving")
		finished.emit("move")
	else:
		finished.emit("shoot")
