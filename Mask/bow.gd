class_name Bow extends Weapon


@onready var bow_draw : TextureProgressBar = $BowDraw

@export var bow_draw_speed := 5
const ARROW = preload("uid://dmtp64o0wma7d")


func _physics_process(delta: float) -> void:
	phy_update(delta)


func input_handle() -> void:
	if Input.is_action_pressed("attack"):
		bow_draw.value += bow_draw_speed
	if Input.is_action_just_released("attack"):
		shoot_arrow()


func shoot_arrow() -> void:
	var arrow : Arrow = ARROW.instantiate()
	arrow.global_position = global_position
	arrow.global_position += 32 * Vector2.from_angle(rotation)
	arrow.velocity = Vector2.from_angle(rotation) * arrow.move_speed * (bow_draw.value / bow_draw.max_value)
	arrow.rotation = rotation
	get_tree().current_scene.add_child(arrow)

	bow_draw.value = 0
