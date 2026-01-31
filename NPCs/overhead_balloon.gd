extends NinePatchRect
@onready var label: RichTextLabel = $MarginContainer/Label
@onready var timer: Timer = $Timer

var visible_characters := 0.0
var typing := false
@export var text := "I got NOTHING to say."

func start_typing() -> void:
	show()
	typing = true
	var tween = create_tween().bind_node(self)
	tween.tween_property(self, "visible_characters", text.length(), 1.0)
	tween.tween_callback(timer.start)

func _process(_delta: float) -> void:
	label.text = text.substr(0, visible_characters)

func _on_timer_timeout() -> void:
	hide()
	visible_characters = 0
