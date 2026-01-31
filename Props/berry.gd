class_name Berry extends CharacterBody2D

var plucked := false
var pickable := false
@export var pluck_speed = 100.0

func drop() -> void:
	plucked = true
	pickable = true
	velocity = Vector2.from_angle(randf_range(-PI, PI)) * pluck_speed
	create_tween().tween_property(self, "velocity", Vector2.ZERO, 1.0)

func pickup(mask:Mask) -> String:
	mask.health.value += 10
	queue_free()
	return "eat"

func _physics_process(delta: float) -> void:
	move_and_slide()
