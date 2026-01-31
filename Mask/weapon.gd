class_name Weapon extends Area2D

enum SLASH_TYPES { NONE, DOWNWARD, UPWARD }
var slash_type = SLASH_TYPES.NONE

var target_degrees	: float = rotation
var target_rotation	: float = rotation

var attacking := false

var hit_list : Array

func phy_update(delta:float) -> void:
	if !attacking:
		var screen_center = get_viewport().get_visible_rect().size/2
		var mouse_pos = get_viewport().get_mouse_position() - screen_center
		var angle = mouse_pos.angle()

		rotation = wrapf(lerp_angle(rotation, angle - PI, 50.0 * delta), -PI, PI)

#func get_mouse_angle() -> float:
#	var screen_center = get_viewport().get_visible_rect().size/2
#	var mouse_pos = get_viewport().get_mouse_position() - screen_center
#	var mouse_angle = mouse_pos.angle()
#	return mouse_angle
