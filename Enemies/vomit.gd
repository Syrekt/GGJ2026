class_name Vomit extends CharacterBody2D

@export var move_speed := 10.0 * 60.0
@onready var hitbox: Area2D = $Hitbox
var damage := 1.0


func _physics_process(delta: float) -> void:
	move_and_slide()

	for body in hitbox.get_overlapping_bodies():
		if body is Mask:
			body.take_damage(self, damage)
		hide()
		queue_free()
		break;

	for area in hitbox.get_overlapping_areas():
		hide()
		queue_free()
		break;


func _on_lifetime_timeout() -> void:
	queue_free()
