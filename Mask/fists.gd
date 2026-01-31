class_name Fists extends Weapon

@export var attack_force := 2.0 * 60.0
var attack_speed : Vector2

var tween_position : Tween
var attack_buffered := false
var can_buffer := false

func _process(delta: float) -> void:
	Debugger.printui("position: "+str(position))
	Debugger.printui("attacking: "+str(attacking))

	if can_buffer && Input.is_action_just_pressed("attack"):
		attack_buffered = true

func _physics_process(delta: float) -> void:
	phy_update(delta)

	if attacking:
		for child in get_overlapping_bodies():
			if !hit_list.has(child):
				child.take_damage(self)
				hit_list.append(child)

		for child in get_overlapping_areas():
			if !hit_list.has(child):
				child.take_damage(self) # Doesn't deal damage, just plays sfx
				hit_list.append(child)



func input_handle() -> void:
	if (attack_buffered || Input.is_action_just_pressed("attack")) && !attacking:
		attack_buffered = false
		$WooshSFX.play()
		attacking = true
		hit_list.clear()

		if tween_position:
			tween_position.kill()

		tween_position = create_tween().bind_node(self)
		var target_position = Vector2.from_angle(rotation + PI*0.5) * attack_force
		print("target_position: "+str(target_position))
		tween_position.tween_property(self, "position", target_position, 0.1)
		tween_position.tween_callback(set.bind("can_buffer", true)).set_delay(0.1)
		tween_position.set_parallel()
		tween_position.tween_property(self, "position", Vector2.ZERO, 0.3)
		tween_position.set_parallel(false)
		tween_position.tween_callback(set.bind("attacking", false))
		tween_position.tween_callback(set.bind("can_buffer", false))
