class_name Mask extends CharacterBody2D

@export var direction	:= Vector2(1, 0)
@export var move_speed	:= 10.0 * 600.0

@export var knockback_force := 50.0 * 600.0
var knockback_speed := Vector2.ZERO

@onready var npc_detector := $NPCDetector

@onready var health: TextureProgressBar = $UI/Control/VBoxContainer/Health

var weapon : Weapon
var sword_resource	:= preload("res://Mask/sword.tscn")
var fists_resource	:= preload("res://Mask/fists.tscn")
var bow_resource	:= preload("res://Mask/bow.tscn")

@onready var sprite : Sprite2D = $Sprite2D
@onready var quest	: Label = $UI/Control/Quest

@export var ranger_tex	: Texture
@export var fighter_tex : Texture
@export var brawler_tex : Texture

var interaction_target

enum CLASSES { FIGHTER, RANGER, BRAWLER}
@export var mask_class : CLASSES


func _ready() -> void:
	quest.text = "Bring 3 woods"

	update_class()

func _process(delta: float) -> void:
	Debugger.printui("direction: "+str(direction))
	$AnimationTree.set("parameters/blend_position", direction)

	Debugger.printui("interaction_target: "+str(interaction_target))
	if interaction_target:
		if Input.is_action_just_pressed("interact"):
			interaction_target.interact()
		if !npc_detector.has_overlapping_areas():
			interaction_target = null

func _physics_process(delta: float) -> void:
	velocity += knockback_speed * delta
	move_and_slide()

func update_move_dir() -> void:
	direction = Vector2(
		float(Input.is_action_pressed("right")) - float(Input.is_action_pressed("left")),
		float(Input.is_action_pressed("down")) - float(Input.is_action_pressed("up"))
	)
func take_damage(source:Node2D, damage:=1) -> void:
	health.value -= damage
	var tween = create_tween().bind_node(self)
	tween.tween_property(sprite.material, "shader_parameter/tint_color", Color(1, 0, 0, 1), 0.2)
	tween.tween_property(sprite.material, "shader_parameter/tint_color", Color(1, 1, 1, 0), 0.2)

	knockback_speed = source.global_position.direction_to(global_position) * knockback_force
	create_tween().bind_node(self).tween_property(self, "knockback_speed", Vector2(0, 0), 0.2)

	var tween_scale = create_tween().bind_node(self)
	tween_scale.tween_property(sprite, "scale", Vector2(1.2, 1.2), 0.1)
	tween_scale.tween_property(sprite, "scale", Vector2(1, 1), 0.1)

	var tween_rot = create_tween().bind_node(self).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween_rot.tween_property(sprite, "rotation_degrees", randi_range(-45, 45), 0.2)
	tween_rot.tween_property(sprite, "rotation_degrees", 0, 0.1)

	$HurtEvent.play()

func update_class() -> void:
	if weapon:
		weapon.queue_free()
	match mask_class:
		CLASSES.FIGHTER:
			weapon = sword_resource.instantiate()
		CLASSES.RANGER:
			weapon = bow_resource.instantiate()
		CLASSES.BRAWLER:
			weapon = fists_resource.instantiate()
	add_child(weapon)

func _on_npc_detector_area_entered(area: Area2D) -> void:
	interaction_target = area.owner
