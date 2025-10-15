class_name Dice extends Control 

@onready var color_rect := $ColorRect
@export var player_number: int = 1
@onready var label := $Label
@onready var dice_value: int = 1
var is_special: bool = false


func _ready() -> void:
	match player_number:
		1:
			color_rect.color = Color(0.7,0,0)
		2:
			color_rect.color = Color(0,0,0.7)
		_:
			color_rect.color = Color(0,0,0)

func throw_me() -> void:
	dice_value = randi() % 6
	if dice_value != 0:
		label.text = str(int(dice_value))
	else:
		label.text = "!"
		is_special = true
