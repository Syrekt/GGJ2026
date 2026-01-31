class_name Bush extends Area2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var berry_list : Array[Berry]

var harvested := false


func take_damage(source,damage:=1) -> void:
	$HitSFX.play()
	if harvested: return

	var berry = berry_list.pop_front()
	berry.drop()
	
	if berry_list.size() == 0:
		harvested = true
