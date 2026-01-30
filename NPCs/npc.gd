class_name NPC extends Node2D


@export var BALLOON = preload("res://balloon.tscn")
var dialogue_resource : DialogueResource


var balloon = null

@export_multiline var text := ""

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended);
	dialogue_resource = DialogueManager.create_resource_from_text("~ title\n" + text)

func _on_dialogue_ended(resource: DialogueResource) -> void:
	pass


func interact() -> void:
	print("interacted")
	balloon = BALLOON.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_resource, "title")
