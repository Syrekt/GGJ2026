class_name Weapon extends Area2D

enum SLASH_TYPES { NONE, DOWNWARD, UPWARD }
var slash_type = SLASH_TYPES.NONE

var target_rotation	: float = rotation
@export var rotation_offset : float

@export var attacking := false

@onready var hit_sfx := $HitSFX
@onready var death_sfx := $DeathSFX

var hit_list : Array

@export var lock_direction_while_attacking := true

func phy_update(delta:float) -> void:
	if !lock_direction_while_attacking || !attacking:
		var screen_center = get_viewport().get_visible_rect().size/2
		var mouse_pos = get_viewport().get_mouse_position() - screen_center
		var angle = mouse_pos.angle()

		rotation = wrapf(lerp_angle(rotation, angle + rotation_offset, 50.0 * delta), -PI, PI)

func input_handle() -> void:
	pass

#func get_mouse_angle() -> float:
#	var screen_center = get_viewport().get_visible_rect().size/2
#	var mouse_pos = get_viewport().get_mouse_position() - screen_center
#	var mouse_angle = mouse_pos.angle()
#	return mouse_angle
