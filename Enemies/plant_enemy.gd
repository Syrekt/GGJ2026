class_name PlantEnemy extends Enemy
const VOMIT = preload("uid://c7jyf6wa35v3i")

@onready var state_node := $StateMachine


func _ready() -> void:
	got_hurt.connect(_on_hurt)

func _on_hurt() -> void:
	if hp_cur <= 0:
		state_node.state.finished.emit("dead")
	else:
		state_node.state.finished.emit("hurt")

func _process(delta: float) -> void:
	Debugger.printui("velocity: "+str(velocity))
	Debugger.printui("sprite.animation: "+str(sprite.animation));
	var state = state_node.state
	Debugger.printui("state.name: "+str(state.name));
	if grabbed: return
	if dead:
		if state_node.state.name != "dead":
			state_node.state.finished.emit("dead")
		return
	if thrown: return


	

func _physics_process(delta: float) -> void:
	move_and_slide()

func shoot() -> void:
	print("Shoot")
	if !mask: 
		print("Can't find Mask")
		mask = Game.get_singleton().mask

	var vomit = VOMIT.instantiate()
	vomit.global_position = global_position
	var angle = global_position.angle_to_point(mask.global_position)
	vomit.global_position += 16 * Vector2.from_angle(angle)
	vomit.velocity = Vector2.from_angle(angle) * 300.0
	vomit.rotation = angle
	vomit.damage = damage
	get_tree().current_scene.add_child(vomit)
