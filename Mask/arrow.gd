class_name Arrow extends CharacterBody2D

@export var move_speed := 10.0 * 60.0
@onready var hitbox: Area2D = $Hitbox
@onready var hit_sfx: FmodEventEmitter2D = $HitSFX
@onready var death_sfx: FmodEventEmitter2D = $DeathSFX


func _physics_process(delta: float) -> void:
	move_and_slide()

	for body in hitbox.get_overlapping_bodies():
		print("body: "+str(body))
		if body is Enemy:
			body.take_damage(self)
		print("self: "+str(self))
		queue_free()
		break;

	for area in hitbox.get_overlapping_areas():
		print("area: "+str(area))
		queue_free()
		break;


func _on_lifetime_timeout() -> void:
	queue_free()
