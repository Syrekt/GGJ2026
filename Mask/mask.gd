class_name Mask extends CharacterBody2D

@onready var state_node := $StateMachine

@export var direction	:= Vector2(1, 0)
@export var move_speed	:= 10.0 * 600.0

@export var knockback_force := 50.0 * 600.0
var knockback_speed := Vector2.ZERO

@onready var npc_detector := $NPCDetector

@onready var health: TextureProgressBar = $UI/Control/VBoxContainer/Health
@onready var weapon_charge: TextureProgressBar = $WeaponCharge

var weapon : Weapon
var sword_resource	:= preload("res://Mask/sword.tscn")
var fists_resource	:= preload("res://Mask/fists.tscn")
var bow_resource	:= preload("res://Mask/bow.tscn")

@onready var sprite : Sprite2D = $Sprite2D
@onready var quest	: Label = $UI/Control/Quest
@onready var restart_menu: CanvasLayer = $"Restart Menu"
@onready var pickup_collider: Area2D = $PickupCollider
@onready var grab_range: Area2D = $GrabRange
@onready var anim_player: AnimationPlayer = $AnimationPlayer

@export var ranger_tex	: Texture
@export var fighter_tex : Texture
@export var brawler_tex : Texture


var interaction_target
var dead := false

enum CLASSES { FIGHTER, RANGER, BRAWLER}
@export var mask_class : CLASSES
var class_string : String


func _ready() -> void:
	quest.text = "Bring 3 woods"
	restart_menu.hide()

	update_class()

func _process(delta: float) -> void:
	if interaction_target:
		if Input.is_action_just_pressed("interact"):
			interaction_target.interact()
		if !npc_detector.has_overlapping_areas():
			interaction_target = null
	
	if Input.is_action_just_pressed("fighter"):
		mask_class = CLASSES.FIGHTER
		update_class()
	elif Input.is_action_just_pressed("ranger"):
		mask_class = CLASSES.RANGER
		update_class()
	elif Input.is_action_just_pressed("brawler"):
		mask_class = CLASSES.BRAWLER
		update_class()

	if weapon:
		weapon_charge.visible = weapon_charge.value > weapon.charge_speed * 20.0


	var state_name = state_node.state.name
	Debugger.printui("knockback_speed: "+str(knockback_speed))
	Debugger.printui("state: "+str(state_name))



func _physics_process(delta: float) -> void:
	velocity += knockback_speed * delta
	move_and_slide()

	for pickup in pickup_collider.get_overlapping_bodies():
		if pickup.pickable:
			var sfx_type = pickup.pickup(self)
			match sfx_type:
				"eat":
					$EatSFX.play()


func move(delta:float,speed_mod:=1.0) -> void:
	velocity = Vector2(
		float(Input.is_action_pressed("right")) - float(Input.is_action_pressed("left")),
		float(Input.is_action_pressed("down")) - float(Input.is_action_pressed("up"))
	) * move_speed * speed_mod * delta

	if velocity.x != 0: direction.x = sign(velocity.x)
	if velocity.y != 0: direction.y = sign(velocity.y)
func take_damage(source:Node2D, damage:=1) -> void:
	if state_node.state.name == "dodge": return


	health.value -= damage
	var tween = create_tween().bind_node(self)
	tween.tween_property(sprite.material, "shader_parameter/tint_color", Color(1, 0, 0, 1), 0.2)
	tween.tween_property(sprite.material, "shader_parameter/tint_color", Color(1, 1, 1, 0), 0.2)

	knockback_speed = source.global_position.direction_to(global_position) * knockback_force
	create_tween().tween_property(self, "knockback_speed", Vector2(0, 0), 0.2)

	var tween_scale = create_tween().bind_node(self)
	tween_scale.tween_property(sprite, "scale", Vector2(1.2, 1.2), 0.1)
	tween_scale.tween_property(sprite, "scale", Vector2(1, 1), 0.1)

	var tween_rot = create_tween().bind_node(self).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween_rot.tween_property(sprite, "rotation_degrees", randi_range(-45, 45), 0.2)
	tween_rot.tween_property(sprite, "rotation_degrees", 0, 0.1)

	$HurtEvent.play()

	if health.value <= 0:
		restart_menu.show()

	state_node.state.finished.emit("hurt")


func update_class() -> void:
	if weapon:
		weapon.queue_free()
	match mask_class:
		CLASSES.FIGHTER:
			weapon = sword_resource.instantiate()
			class_string = "fighter"
		CLASSES.RANGER:
			weapon = bow_resource.instantiate()
			class_string = "ranger"
		CLASSES.BRAWLER:
			weapon = fists_resource.instantiate()
			class_string = "brawler"
	weapon.mask = self
	add_child(weapon)

	state_node.state.enter(state_node.state.name)

func _on_npc_detector_area_entered(area: Area2D) -> void:
	interaction_target = area.owner


func _on_restart_pressed() -> void:
	get_tree().current_scene.restart_game()


func _on_exit_pressed() -> void:
	get_tree().quit()

func update_animation() -> void:
	match mask_class:
		CLASSES.FIGHTER:
			if health.value <= 0:
				if !dead:
					dead = true
					match direction:
						Vector2(1, 1):
							anim_player.play("fighter_death_dright")
						Vector2(-1, 1):
							anim_player.play("fighter_death_dleft")
						Vector2(1, -1):
							anim_player.play("fighter_death_uright")
						Vector2(-1, 1):
							anim_player.play("fighter_death_uleft")
			elif velocity == Vector2.ZERO:
				Debugger.printui("direction: "+str(direction))
				if direction.x == 1:
					anim_player.play("fighter_idle_right")
				else:
					anim_player.play("fighter_idle_left")
			else:
				Debugger.printui("velocity: "+str(velocity))
				match direction:
					Vector2(1, 1):
						anim_player.play("fighter_dright")
					Vector2(-1, 1):
						anim_player.play("fighter_dleft")
					Vector2(1, -1):
						anim_player.play("fighter_uright")
					Vector2(-1, -1):
						anim_player.play("fighter_uleft")
