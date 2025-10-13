extends Node

@onready var background_color := Color(0.7,0.7,0)
var players: Array = []
var current_round: int = 0

func _ready() -> void:
	# CHARACTER POINTS; CHARACTER TYPE
	# GOLD; RESOURCES; HP
	players.append([0, 0])
	players.append(["???", "???"])
	players.append([0, 0])
	for i in 4:
		players.append([0, 0])
	players.append([3, 3])
