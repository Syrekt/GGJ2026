extends State

func enter(previous_state_path: String, data := {}) -> void:
	owner.sprite.play("submerge")

	if !owner.sprite.is_connected("animation_finished", _on_animation_finished):
		owner.sprite.animation_finished.connect(_on_animation_finished)

func _on_animation_finished() -> void:
	finished.emit("move")
