class_name PlayerWeapon extends Weapon



func _physics_process(delta: float) -> void:
	phy_update(delta)

	var diff = abs(wrapf(rotation - target_rotation, -PI, PI))

	if diff < deg_to_rad(0.1):
		attacking = false
		slash_type = SLASH_TYPES.NONE
	else:
		rotation = wrapf(lerp_angle(rotation, target_rotation, 20.0 * delta), -PI, PI)

	if attacking:
		for child in get_overlapping_bodies():
			if !hit_list.has(child):
				child.take_damage(self)
				hit_list.append(child)

		for child in get_overlapping_areas():
			if !hit_list.has(child):
				child.take_damage(self)
				hit_list.append(child)



func input_handle() -> void:
	if Input.is_action_just_pressed("attack"):
		$WhooshSFX.play()
		attacking = true
		var attack_angle = PI * 0.8
		hit_list.clear()
		match slash_type:
			SLASH_TYPES.NONE:
				target_rotation = rotation + attack_angle
				slash_type = SLASH_TYPES.DOWNWARD
			SLASH_TYPES.DOWNWARD:
				target_rotation = rotation - attack_angle
				slash_type = SLASH_TYPES.UPWARD
			SLASH_TYPES.UPWARD:
				target_rotation = rotation + attack_angle
				slash_type = SLASH_TYPES.DOWNWARD
