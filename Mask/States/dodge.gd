extends State

var tween : Tween

func enter(previous_state_path: String, data := {}) -> void:
	owner.weapon_charge.value = 0
	owner.anim_player.speed_scale = 1.5
	if owner.direction.x == 1:
		owner.anim_player.play("ranger_dodge_right")
	else:
		owner.anim_player.play("ranger_dodge_left")

	if !owner.anim_player.is_connected("animation_finished", _on_animation_finished):
		owner.anim_player.animation_finished.connect(_on_animation_finished)

	owner.velocity *= 4
	if tween: tween.kill()
	tween = create_tween().bind_node(self)
	tween.tween_property(owner, "velocity", Vector2.ZERO, 0.5).set_ease(Tween.EASE_OUT)

func _on_animation_finished(anim:String) -> void:
	if owner.state_node.state == self:
		finished.emit("idle")
		owner.anim_player.speed_scale = 1

