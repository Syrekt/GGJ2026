extends Node2D


@export var mask: Mask

func _ready() -> void:
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
	DisplayServer.window_set_size(Vector2(1280, 720))
	#DisplayServer.window_set_current_screen(window_screen)
	var _window_size	:= DisplayServer.window_get_size()
	var display_size	:= DisplayServer.screen_get_size(0)
	print("window_size: "+str(_window_size))
	print("display_size: "+str(display_size))

	DisplayServer.window_set_position((display_size - _window_size) / 2)
