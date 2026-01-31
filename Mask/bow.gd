class_name Bow extends Weapon


const ARROW = preload("uid://dmtp64o0wma7d")

func _physics_process(delta: float) -> void:
	phy_update(delta)


func input_handle() -> void:
	if Input.is_action_just_pressed("attack"):
		$DrawSFX.play()
	if Input.is_action_pressed("attack"):
		mask.weapon_charge.value += weapon_charge_speed
	if Input.is_action_just_released("attack"):
		shoot_arrow()


func shoot_arrow() -> void:
	$ShootSFX.play()
	var arrow : Arrow = ARROW.instantiate()
	var sway = deg_to_rad(lerpf(randf_range(-30, 30), 0, mask.weapon_charge.value / mask.weapon_charge.max_value))
	arrow.global_position = global_position
	arrow.global_position += 16 * Vector2.from_angle(rotation)
	arrow.velocity = Vector2.from_angle(rotation + sway) * arrow.move_speed * (mask.weapon_charge.value / mask.weapon_charge.max_value)
	arrow.rotation = rotation + sway
	get_tree().current_scene.add_child(arrow)

	mask.weapon_charge.value = 0
