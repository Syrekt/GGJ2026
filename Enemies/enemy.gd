class_name Enemy extends CharacterBody2D

var mask : Mask

var on_chase := false

@export var move_speed := 9.0 * 600.0
@onready var hurt_timer: Timer = $HurtTimer

@export var hp_max := 3
var hp_cur = hp_max

@export var knockback_force_hurt	:= 50.0 * 600.0
@export var knockback_force_death	:= 10.0 * 600.0
var knockback_speed := Vector2.ZERO
var rotation_speed := 0.0

var dead := false

@onready var sprite : Sprite2D = $Sprite2D

var tween_knockback : Tween

func _ready() -> void:
	mask = get_tree().current_scene.mask

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if dead:
		rotate(rotation_speed)
		Debugger.printui("rotation: "+str(rotation))
		velocity = Vector2.ZERO
	else:
		if on_chase:
			var direction : Vector2 = global_position.direction_to(mask.global_position)
			velocity = direction * move_speed * delta

		if $Hurtbox.has_overlapping_bodies():
			if hurt_timer.is_stopped():
				mask.take_damage(self)


	velocity += knockback_speed * delta
	move_and_slide()

func _on_detection_area_body_entered(_body: Node2D) -> void:
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
		$DeathSFX.play()
		print("dead")
		dead = true

		rotation_speed = 0.2
		create_tween().bind_node(self).tween_property(self, "rotation_speed", 0, 2)

		knockback_speed = source.global_position.direction_to(global_position) * knockback_force_death
		tween_knockback.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC).tween_property(self, "knockback_speed", Vector2(0, 0), 1.0)

		create_tween().tween_property(sprite.material, "shader_parameter/tint_color", Color(0, 0, 0, 1), 1.0)
	else:
		knockback_speed = source.global_position.direction_to(global_position) * knockback_force_hurt
		tween_knockback.tween_property(self, "knockback_speed", Vector2(0, 0), 0.2)
		$HurtSFX.play()
