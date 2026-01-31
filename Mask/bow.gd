class_name Bow extends Weapon


@export var bow_draw_speed := 0.5
const ARROW = preload("uid://dmtp64o0wma7d")

func _physics_process(delta: float) -> void:
	phy_update(delta)


func input_handle() -> void:
	if Input.is_action_just_pressed("attack"):
		$DrawSFX.play()
	if Input.is_action_pressed("attack"):
		mask.bow_draw.value += bow_draw_speed
	if Input.is_action_just_released("attack"):
		shoot_arrow()


func shoot_arrow() -> void:
	$ShootSFX.play()
	var arrow : Arrow = ARROW.instantiate()
	var sway = deg_to_rad(lerpf(randf_range(-30, 30), 0, mask.bow_draw.value / mask.bow_draw.max_value))
	arrow.global_position = global_position
	arrow.global_position += 16 * Vector2.from_angle(rotation)
	arrow.velocity = Vector2.from_angle(rotation + sway) * arrow.move_speed * (mask.bow_draw.value / mask.bow_draw.max_value)
	arrow.rotation = rotation + sway
	get_tree().current_scene.add_child(arrow)

	mask.bow_draw.value = 0
