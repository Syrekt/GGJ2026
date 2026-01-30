class_name PlayerWeapon extends CharacterBody2D

@onready var mask: Mask = $".."

var target_degrees	: float = rotation
var target_rotation	: float = rotation


enum SLASH_TYPES { NONE, DOWNWARD, UPWARD }
var slash_type = SLASH_TYPES.NONE
var attacking := false


func _physics_process(delta: float) -> void:
	var diff = abs(wrapf(rotation - target_rotation, -PI, PI))

	if diff < deg_to_rad(0.1):
		attacking = false
		slash_type = SLASH_TYPES.NONE
	else:
		rotation = wrapf(lerp_angle(rotation, target_rotation, 20.0 * delta), -PI, PI)

	if !attacking:
		var screen_center = get_viewport().get_visible_rect().size/2
		var mouse_pos = get_viewport().get_mouse_position() - screen_center
		var angle = mouse_pos.angle()

		#rotation_degrees = angle - 130
		rotation = wrapf(lerp_angle(rotation, angle - PI, 50.0 * delta), -PI, PI)
		#rotate(0.6)


func get_mouse_angle() -> float:
	var screen_center = get_viewport().get_visible_rect().size/2
	var mouse_pos = get_viewport().get_mouse_position() - screen_center
	var mouse_angle = mouse_pos.angle()
	return mouse_angle

func attack() -> void:
	attacking = true
	var attack_angle = PI * 0.8
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
