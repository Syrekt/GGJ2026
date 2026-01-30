extends Area2D

@export var hp_max = 3
var hp_cur = hp_max

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var drop := preload("res://Drops/log.tscn")


func take_damage(damage:=1) -> void:
	print("hurt")
	sprite.play("hurt")
	hp_cur -= damage

	var _drop := drop.instantiate()
	_drop.global_position = global_position
	get_tree().current_scene.add_child(_drop)

	if hp_cur <= 0:
		sprite.play("cut")



func _on_body_entered(body: Node2D) -> void:
	if sprite.animation == "cut": return

	if body is PlayerWeapon:
		take_damage()


func _on_animated_sprite_2d_animation_finished() -> void:
	print("sprite.animation: "+str(sprite.animation));
	if sprite.animation == "hurt":
		sprite.play("idle")
