class_name Mask extends CharacterBody2D

@export var direction	:= Vector2(1, 0)
@export var move_speed	:= 5.0 * 60

@onready var npc_detector := $NPCDetector

@onready var sword : CharacterBody2D = $Sword
@onready var health: TextureProgressBar = $CanvasLayer/Control/Health

var interaction_target


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
	move_and_slide()

func update_move_dir() -> void:
	direction = Vector2(
		float(Input.is_action_pressed("right")) - float(Input.is_action_pressed("left")),
		float(Input.is_action_pressed("down")) - float(Input.is_action_pressed("up"))
	)





func _on_npc_detector_area_entered(area: Area2D) -> void:
	interaction_target = area.owner
