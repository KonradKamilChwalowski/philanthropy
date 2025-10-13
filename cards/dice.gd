extends Control

@onready var color_rect := $ColorRect
@export var player_number: int = 1
@onready var label := $Label


func _ready() -> void:
	match player_number:
		1:
			color_rect.color = Color(0.7,0,0)
		2:
			color_rect.color = Color(0,0,0.7)
		_:
			color_rect.color = Color(0,0,0)
