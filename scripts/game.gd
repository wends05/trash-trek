extends Node


var energy = 0

signal trash_collected(type: Utils.TrashType)

var collected_biodegradable = 0
var collected_recyclable = 0
var collected_toxic_waste = 0

func _ready() -> void:
	trash_collected.connect(update_trash_count)

signal energy_changed(value: int)

func add_energy(amount: float) -> void:
	energy += amount
	energy_changed.emit(energy)

signal updated_stats

func update_trash_count(type: Utils.TrashType):
	if type == Utils.TrashType.Recyclable:
		collected_recyclable += 1
		add_energy(2)
	if type == Utils.TrashType.Biodegradable:
		collected_biodegradable += 1
		add_energy(3)
	if type == Utils.TrashType.ToxicWaste:
		collected_toxic_waste += 1
		add_energy(5)
	updated_stats.emit()
	
