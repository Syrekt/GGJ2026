class_name PlantEnemy extends Enemy
const VOMIT = preload("uid://c7jyf6wa35v3i")

func _process(delta: float) -> void:
	if grabbed: return
	if dead: return
	if thrown: return

func shoot() -> void:
	if !mask: 
		print("Can't find Mask")
		return

	var vomit = VOMIT.instantiate()
	vomit.global_position = global_position
	vomit.global_position += 16 * Vector2.from_angle(rotation)
	vomit.velocity = Vector2.from_angle(rotation) * 3000.0
	vomit.rotation = rotation
	vomit.damage = damage
	get_tree().current_scene.add_child(vomit)
