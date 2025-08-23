extends Area2D

class_name Trash

@export var type: Utils.TrashType

@onready var energy_bar: ProgressBar = $"../Energy"
var energy_value: float = 0.0

func _ready() -> void:
	add_to_group("Trash")
	
func add_energy(amount: float) -> void:
	energy_value = clamp(energy_value + amount, 0, 100)
	energy_bar.value = lerp(energy_bar.value, energy_value, 1)
	
func _on_body_entered(body: Node) -> void:
	pick_trash(body)
	
func pick_trash(player: Node):
	if player.is_in_group('Player'):
		add_energy(20)
		queue_free()
		
