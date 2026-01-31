extends Area2D

@export var hp_max = 3
var hp_cur = hp_max

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var drop := preload("res://Drops/log.tscn")


func take_damage(source,damage:=1) -> void:
	if sprite.animation == "cut": return

	$ChopSFX.play()
	if source is Fists: return

	print("hurt")
	sprite.play("hurt")
	hp_cur -= damage

	var _drop := drop.instantiate()
	_drop.global_position = global_position
	get_tree().current_scene.add_child(_drop)

	if hp_cur <= 0:
		sprite.play("cut")

	var ttime = 0.1
	var tween_scale = create_tween().bind_node(self)
	tween_scale.tween_property(sprite, "scale", Vector2(0.05, 0.05), ttime).as_relative()
	tween_scale.tween_property(sprite, "scale", Vector2(1, 1), ttime)

	ttime = 0.2
	var tween_rot = create_tween().bind_node(self).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween_rot.tween_property(sprite, "rotation_degrees", randi_range(-2, 2), ttime)
	tween_rot.tween_property(sprite, "rotation_degrees", 0, ttime)



func _on_animated_sprite_2d_animation_finished() -> void:
	print("sprite.animation: "+str(sprite.animation));
	if sprite.animation == "hurt":
		sprite.play("idle")
