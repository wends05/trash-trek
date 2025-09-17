extends Node2D

@onready var anim_player = $AnimationPlayer
@onready var steps = ["Start", "1 energy bar", "2 Trash", "3 Monster", "4 TrashCan", "5 Trash Buttons", "6 Game Over"]
@onready var instruction_label = $Label
@onready var instructions = [
	"Welcome to the tutorial. Press the right arrow to navigate.",
	"This is your energy bar. If it runs out, it's game over.",
	"Collect trash and sort it later on the trash cans.",
	"Beware of monsters. They can deplete your energy.",
	"Sort your trash properly to gain energy, but take note of the quantity needed.",
	"Use the Z, X, and C buttons to select what type of trash goes into the colored trash bins, you can also see the number of trash collected.",
	"Be careful of cliffs, They mean instant death. Use the space bar to jump over them!"
]

var current_step := 0

# typing animation vars
var full_text := ""
var char_index := 0
var typing_speed := 0.02  # seconds per character
var typing_timer := Timer.new()

func _ready():
	instruction_label.add_theme_font_size_override("font_size", 16)
	add_child(typing_timer)
	typing_timer.one_shot = false
	typing_timer.wait_time = typing_speed
	typing_timer.connect("timeout", Callable(self, "_on_typing_step"))
	play_step()

func _input(event):
	if event.is_action_pressed("ui_text_caret_right"):
		next_step()
	elif event.is_action_pressed("ui_text_caret_left"):
		prev_step()
	elif event.is_action_pressed("ui_accept"):
		if typing_timer.is_stopped() == false:
			typing_timer.stop()
			instruction_label.text = full_text

func play_step():
	anim_player.play(steps[current_step])
	start_typing(instructions[current_step])

func start_typing(text_to_type: String):
	full_text = text_to_type
	char_index = 0
	instruction_label.text = ""
	typing_timer.start()

func _on_typing_step():
	if char_index < full_text.length():
		instruction_label.text += full_text[char_index]
		char_index += 1
	else:
		typing_timer.stop()

func next_step():
	if current_step < steps.size() - 1:
		current_step += 1
		play_step()

func prev_step():
	if current_step > 0:
		current_step -= 1
		play_step()

func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
	
