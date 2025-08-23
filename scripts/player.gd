extends CharacterBody2D

class_name Player

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	add_to_group("Player")
		
func _physics_process(delta: float) -> void:      
	player_gravity(delta)
	player_jump()
	move_and_slide()
	
func player_jump() -> void:
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func player_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta


func _on_trash_collection_area_body_entered(body: Node2D) -> void:
	if body is Trash:
		var trash_type = body.type
		print_debug("Collected Trash: " + trash_type)
		increment_trash(trash_type)

func increment_trash(type: Utils.TrashType):
	if type == Utils.TrashType.Recyclable:
		Game.collected_recyclable += 1
	if type == Utils.TrashType.Biodegradable:
		Game.collected_biodegradable += 1
	if type == Utils.TrashType.ToxicWaste:
		Game.collected_toxic_waste += 1
	
		
