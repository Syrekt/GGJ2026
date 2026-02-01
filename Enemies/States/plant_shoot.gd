extends State

@onready var timer := $ShootTimer

func enter(previous_state_path: String, data := {}) -> void:
	owner.sprite.play("shoot")
	timer.timeout.connect(_on_shoot_timer_timeout)
	timer.start()

func exit() -> void:
	timer.timeout.disconnect(_on_shoot_timer_timeout)


func _on_shoot_timer_timeout() -> void:
	owner.shoot()
