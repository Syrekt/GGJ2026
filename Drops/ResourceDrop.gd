extends Node2D


func _ready() -> void:
	#create_tween().bind_node(self).tween_property(self, "position:y", position.y - 36, 2)
	create_tween().bind_node(self).tween_property(self, "modulate", Color(1, 1, 1, 0), 2)

func _process(delta: float) -> void:
	position.y -= 50 * delta
	
