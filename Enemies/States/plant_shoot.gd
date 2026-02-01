extends State

@onready var timer := $ShootTimer

func enter(previous_state_path: String, data := {}) -> void:
	owner.sprite.play("shoot")
	timer.timeout.connect(_on_shoot_timer_timeout)
	timer.start()


func physics_update(_delta: float) -> void:
	if owner.detection_area.has_overlapping_bodies():
		finished.emit("submerge")

func exit() -> void:
	timer.timeout.disconnect(_on_shoot_timer_timeout)

	if owner.sprite.is_connected("animation_finished", _on_shoot_timer_timeout):
		owner.sprite.animation_finished.disconnect(_on_shoot_timer_timeout)

func _on_shoot_timer_timeout() -> void:
	owner.shoot()
	owner.sprite.play("shoot")
	timer.start()
