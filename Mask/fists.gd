class_name Fists extends Weapon

@export var attack_force := 2.0 * 60.0
var attack_speed : Vector2

var tween_position : Tween
var attack_buffered := false
var can_buffer := false

var grabbed_object : Node2D

func _process(delta: float) -> void:
	Debugger.printui("position: "+str(position))
	Debugger.printui("attacking: "+str(attacking))

	if can_buffer && Input.is_action_just_released("attack"):
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
	if Input.is_action_pressed("attack"):
		mask.weapon_charge.value += charge_speed
	if Input.is_action_just_released("attack"):
		if grabbed_object:
			grabbed_object.throw(rotation, 30000.0 * (mask.weapon_charge.value/mask.weapon_charge.max_value))
			mask.weapon_charge.value = 0
			grabbed_object = null
			play_attack_animation()
			return

		if mask.weapon_charge.value == mask.weapon_charge.max_value:
			var grabbed := false

			var grab_range = mask.grab_range
			for grab_object in grab_range.get_overlapping_bodies():
				grab(grab_object)
				grabbed = true
				break;

			mask.weapon_charge.value = 0
			if grabbed: return
		mask.weapon_charge.value = 0

	if (attack_buffered || Input.is_action_just_released("attack")) && !attacking:
		attack_buffered = false
		$WooshSFX.play()
		attacking = true
		hit_list.clear()

		play_attack_animation()

func play_attack_animation() -> void:
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


func grab(node:Node2D) -> void:
	grabbed_object = node
	node.get_grabbed(self)
