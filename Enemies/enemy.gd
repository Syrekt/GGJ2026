class_name Enemy extends CharacterBody2D

var mask : Mask

var on_chase := false

@export var move_speed := 9.0 * 600.0
@export var damage := 10
@export var hp_max := 3
signal got_hurt
var hp_cur = hp_max:
	set(value):
		hp_cur = value
		got_hurt.emit()
@onready var hurt_timer: Timer = $HurtTimer
@onready var detection_area: Area2D = $DetectionArea
@onready var chase_boundaries: Area2D = $ChaseBoundaries


@export var throw_force				:= 10.0 * 600.0
@export var knockback_force_hurt	:= 50.0 * 600.0
@export var knockback_force_death	:= 10.0 * 600.0

var knockback_speed := Vector2.ZERO
var throw_speed		:= Vector2.ZERO
var rotation_speed := 0.0
var rotation_tween : Tween

var dead := false
var grabbed := false
var thrown := false
var tween_throw_speed : Tween

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var starting_pos := global_position
@onready var parent_prv = owner

var tween_knockback : Tween
var throw_damage_dealth := false
var exploding := false

signal on_throw

func _physics_process(delta: float) -> void:
	if grabbed: return

	if exploding:
		rotation = 0
		rotation_speed = 0
	elif dead || thrown:
		rotate(rotation_speed)
	if dead:
		velocity = Vector2.ZERO
	elif !on_chase || thrown:
		velocity = Vector2.ZERO
	else:
		if on_chase:
			var direction : Vector2 = global_position.direction_to(mask.global_position).normalized()
			velocity = direction * move_speed * delta

		if $Hurtbox.has_overlapping_bodies():
			if hurt_timer.time_left == 0:
				hurt_timer.start()
				mask.take_damage(self)


	velocity += (throw_speed + knockback_speed) * delta

	move_and_slide()

	if thrown:
		for i in get_slide_collision_count():
			var collider = get_slide_collision(i).get_collider()
			throw_speed = Vector2.ZERO
			if tween_throw_speed: tween_throw_speed.kill()
			if !throw_damage_dealth && collider.has_method("take_damage"):
				collider.take_damage(self)
				throw_damage_dealth = true
			break

func _on_detection_area_body_entered(body: Node2D) -> void:
	mask = body
	start_chase()

func _on_chase_boundaries_body_exited(_body: Node2D) -> void:
	drop_chase()

func start_chase() -> void:
	on_chase = true
func drop_chase() -> void:
	on_chase = false
	velocity = Vector2.ZERO

func take_damage(source,damage:=1)-> void:
	if hp_cur <= 0: return

	hp_cur -= damage

	if tween_knockback:
		tween_knockback.kill()
	tween_knockback = create_tween()

	if hp_cur <= 0:
		dead = true

		if self is not BombEnemy:
			rotation_speed = 0.2
			if rotation_tween: rotation_tween.kill()
			rotation_tween = create_tween().bind_node(self)
			rotation_tween.tween_property(self, "rotation_speed", 0, 2)

		if source is not Enemy:
			source.death_sfx.play()
	else:
		if source is not Enemy:
			source.hit_sfx.play()


	if !on_chase || hp_cur <= 0:
		knockback_speed = source.global_position.direction_to(global_position) * knockback_force_death
		tween_knockback.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC).tween_property(self, "knockback_speed", Vector2(0, 0), 1.0)
		if hp_cur <= 0:
			create_tween().tween_property(sprite.material, "shader_parameter/tint_color", Color(0, 0, 0, 1), 1.0)
			sprite.play("dead")
			if self is BombEnemy:
				await sprite.animation_finished
				queue_free()
	else:
		knockback_speed = source.global_position.direction_to(global_position) * knockback_force_hurt
		tween_knockback.tween_property(self, "knockback_speed", Vector2.ZERO, 0.2)

	if !on_chase && hp_cur > 0:
		if !mask: mask = Game.get_singleton().mask
		if mask: start_chase()
func get_grabbed(grabbed_by:Fists) -> void:
	reparent(grabbed_by)
	grabbed = true
func throw(dir:float,speed:float) -> void:
	reparent(parent_prv)
	grabbed = false
	throw_speed = Vector2.from_angle(dir + PI/2) * speed
	thrown = true
	throw_damage_dealth = false
	on_throw.emit()

	if tween_throw_speed: tween_throw_speed.kill()

	tween_throw_speed = create_tween()
	tween_throw_speed.tween_property(self, "throw_speed", Vector2.ZERO, 1.0)
	rotation_speed = 0.2

	var tween_rot = create_tween()
	tween_rot.tween_property(self, "rotation_speed", 0, 2)
	tween_rot.tween_property(self, "rotation", 0, 1)
	tween_rot.tween_callback(set.bind("thrown", false))

