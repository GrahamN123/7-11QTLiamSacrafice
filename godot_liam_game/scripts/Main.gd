extends Control

var liam_patience: int = 0
var sacrifices: int = 0

var choices = [
	{"text":"Offer gas money ($5)","patience_change":30,"sacrifice":"money"},
	{"text":"Sacrifice your last bag of chips","patience_change":45,"sacrifice":"snacks"},
	{"text":"Promise to do Liam's chores","patience_change":60,"sacrifice":"time"},
	{"text":"Beg shamelessly","patience_change":15,"sacrifice":"dignity"},
]

@onready var dialogue_label = $VBoxContainer/Dialogue
@onready var choice_container = $VBoxContainer/Choices
@onready var patience_bar = $VBoxContainer/PatienceBar

func _ready():
	_update_ui()

func _update_ui():
	dialogue_label.text = "Liam looks unconvinced. What will you sacrifice?"
	# clear existing choices
	for c in choice_container.get_children():
		c.queue_free()
	for i in range(choices.size()):
		var btn = Button.new()
		btn.text = choices[i]["text"]
		btn.pressed.connect(Callable(self, "_on_choice_pressed").bind(i))
		choice_container.add_child(btn)
	patience_bar.value = liam_patience

func _on_choice_pressed(index: int) -> void:
	var option = choices[index]
	sacrifices += 1
	liam_patience += option["patience_change"]
	# Clamp
	if liam_patience > 100:
		liam_patience = 100
	# Feedback
	dialogue_label.text = "You chose: %s\n(Liam's patience +%d)" % [option["text"], option["patience_change"]]
	# Check outcomes
	if liam_patience >= 100:
		# success -> go to driving scene
		dialogue_label.text = "Victory! Liam sighs, grabs the keys, and agrees to drive. Proceeding to the car..."
		yield(get_tree().create_timer(1.0), "timeout")
		get_tree().change_scene_to_file("res://Driving.tscn")
	elif sacrifices >= 5:
		dialogue_label.text = "Defeat. Liam retreats to his room. No slurpees for you. (Restart to try again)"
		# remove choices and add restart
		for c in choice_container.get_children():
			c.queue_free()
		var r = Button.new()
		r.text = "Restart"
		r.pressed.connect(Callable(self, "_on_restart_pressed"))
		choice_container.add_child(r)
	else:
		_update_ui()

func _on_restart_pressed():
	liam_patience = 0
	sacrifices = 0
	_update_ui()
