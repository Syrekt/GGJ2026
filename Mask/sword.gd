class_name Sword extends Weapon

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var on_fire := false


func _physics_process(delta: float) -> void:
	phy_update(delta)

	var diff = abs(wrapf(rotation - target_rotation, -PI, PI))

	if diff < deg_to_rad(0.1):
		attacking = false
		slash_type = SLASH_TYPES.NONE
	else:
		if attacking:
			rotation = wrapf(lerp_angle(rotation, target_rotation, 20.0 * delta), -PI, PI)
		else:
			var screen_center = get_viewport().get_visible_rect().size/2
			var mouse_pos = get_viewport().get_mouse_position() - screen_center
			var angle = mouse_pos.angle()

			rotation = wrapf(lerp_angle(rotation, angle + rotation_offset, 50.0 * delta), -PI, PI)

	if attacking:
		for child in get_overlapping_bodies():
			if !hit_list.has(child):
				child.take_damage(self, damage)
				hit_list.append(child)
				if on_fire:
					$FireHit.play()

		for child in get_overlapping_areas():
			if !hit_list.has(child):
				child.take_damage(self, damage)
				hit_list.append(child)
				if on_fire:
					$FireHit.play()



func input_handle() -> void:
	if Input.is_action_pressed("attack"):
		mask.weapon_charge.value += charge_speed
		if mask.weapon_charge.value == mask.weapon_charge.max_value:
			set_on_fire()


	if Input.is_action_just_released("attack"):
		mask.weapon_charge.value = 0
		get_tree().create_timer(2.4).timeout.connect(reset_state)
		if on_fire:
			$FireWooshSFX.play()
		else:
			$WooshSFX.play()
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


func set_on_fire() -> void:
	if sprite.animation != "fire_sword":
		sprite.play("fire_sword")
	on_fire = true
func reset_state() -> void:
	sprite.play("default")
	on_fire = false
