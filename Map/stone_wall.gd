extends CharacterBody2D


func take_damage(source,damage:=1) -> void:
	if source is not BombEnemy: return


	queue_free()
