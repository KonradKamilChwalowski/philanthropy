extends Control

@onready var color_rect := $ColorRect
@export var player_number: int = 1
@onready var main_container := $MainContainer
@onready var player_number_label := $MainContainer/PLAYER_NUMBER_LABEL
@onready var character_points_label := $MainContainer/VBoxContainer/CHARACTER_POINTS_LABEL
@onready var character_label := $MainContainer/CHARACTER_LABEL
@onready var resource_container := $ResourceContainer

func _ready() -> void:
	match player_number:
		1:
			color_rect.color = Color(0.7,0,0)
		2:
			color_rect.color = Color(0,0,0.7)
		_:
			color_rect.color = Color(0,0,0)
	update_resources()

func change_language() -> void:
	player_number_label.text = LanguageManager.return_text("GAME_SESSION_SCENE", player_number_label.name)
	character_points_label.text = LanguageManager.return_text("GAME_SESSION_SCENE", character_points_label.name)
	character_label.text = LanguageManager.return_text("GAME_SESSION_SCENE", character_label.name)
	for lbl in resource_container.get_children():
		lbl.text = LanguageManager.return_text("GAME_SESSION_SCENE", lbl.name)

func update_resources() -> void:
	change_language()
	player_number_label.text += str(player_number)
	character_points_label.text += str(GameManager.players[0][player_number-1])
	if GameManager.current_round < 4:
		character_label.text += "???"
	else:
		character_label.text += str(GameManager.players[1][player_number-1])
	for lbl_id in resource_container.get_children().size():
		resource_container.get_child(lbl_id).text += str(GameManager.players[lbl_id+2][player_number-1])
