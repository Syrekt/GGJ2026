extends State

func enter(previous_state_path: String, data := {}) -> void:
	match owner.direction:
		Vector2(1, 1):
			owner.anim_player.play("fighter_hurt_dright")
		Vector2(-1, 1):
			owner.anim_player.play("fighter_hurt_dleft")
		Vector2(1, -1):
			owner.anim_player.play("fighter_hurt_uright")
		Vector2(-1, -1):
			owner.anim_player.play("fighter_hurt_uleft")

	if !owner.anim_player.is_connected("animation_finished", _on_animation_finished):
		owner.anim_player.animation_finished.connect(_on_animation_finished)

func physics_update(delta: float) -> void:
	owner.move(delta, 0.5)


func _on_animation_finished(anim:String) -> void:
	if owner.state_node.state == self:
		finished.emit("idle")
