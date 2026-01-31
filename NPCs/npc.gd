class_name NPC extends Node2D

@export var dialogue_resource : DialogueResource
@export var dialogue_start := "start"
var BALLOON = preload("res://balloon.tscn")
var balloon = null

@export var has_dialogue := false

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended);

func _on_dialogue_ended(_resource: DialogueResource) -> void:
	pass


func interact() -> void:
	print("interacted")
	if has_dialogue:
		balloon = BALLOON.instantiate()
		get_tree().current_scene.add_child(balloon)
		balloon.start(dialogue_resource, dialogue_start)
	else:
		$OverheadBalloon.start_typing()
