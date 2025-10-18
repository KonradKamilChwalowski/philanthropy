extends Node

@onready var main_menu_scene_path: String = "res://main_scenes/main_menu_scene.tscn"
@onready var game_session_settings_scene_path: String = "res://main_scenes/game_session_settings_scene.tscn"
@onready var session_preparing_scene_path: String = "res://main_scenes/session_preparing_scene.tscn"
@onready var game_session_scene_path: String = "res://main_scenes/game_session_scene.tscn"
@onready var p1_dice_number: int = 2
@onready var p2_dice_number: int = 2

@onready var background_color := Color(0.7,0.7,0)
var players: Array = []
var current_round: int = 0

func _ready() -> void:
	# CHARACTER POINTS; CHARACTER TYPE
	# GOLD; RESOURCES; HP
	players.append([0, 0])
	players.append(["???", "???"])
	players.append([10, 10])
	for i in 4:
		players.append([0, 0])
	players.append([3, 3])
