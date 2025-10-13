extends Control

@onready var color_rect := $ColorRect
@export var player_number: int = 1
@onready var hide_button := $HIDE_BUTTON
@onready var whole_container := $VBoxContainer
@onready var player_number_label := $PLAYER_NUMBER_LABEL
@onready var buttons_container := $VBoxContainer/HBoxContainer
@onready var player_character_label := $VBoxContainer/PlayerCharacterLabel


func _ready() -> void:
	match player_number:
		1:
			color_rect.color = Color(0.7,0,0)
		2:
			color_rect.color = Color(0,0,0.7)
		_:
			color_rect.color = Color(0,0,0)
	change_language()

func change_language() -> void:
	hide_button.text = LanguageManager.return_text("PLAYER_CREATION_PANEL", hide_button.name)
	player_number_label.text = LanguageManager.return_text("PLAYER_CREATION_PANEL", player_number_label.name)
	for btn in buttons_container.get_children():
		btn.text = LanguageManager.return_text("PLAYER_CREATION_PANEL", btn.name)
	player_number_label.text += str(player_number)
	match GameManager.players[1][player_number-1]:
		"honest":
			player_character_label.text = LanguageManager.return_text("PLAYER_CREATION_PANEL", "HONEST_TYPE_BUTTON")
		"flexible":
			player_character_label.text = LanguageManager.return_text("PLAYER_CREATION_PANEL", "FLEXIBLE_TYPE_BUTTON")
		"ruthless":
			player_character_label.text = LanguageManager.return_text("PLAYER_CREATION_PANEL", "RUTHLESS_TYPE_BUTTON")
		_:
			player_character_label.text = "???"

func _on_hide_button_pressed() -> void:
	if hide_button.button_pressed:
		whole_container.visible = false
	else:
		whole_container.visible = true
	
func _on_honest_type_button_pressed() -> void:
	GameManager.players[1][player_number-1] = "honest"
	change_language()

func _on_flexible_type_button_pressed() -> void:
	GameManager.players[1][player_number-1] = "flexible"
	change_language()

func _on_ruthless_type_button_pressed() -> void:
	GameManager.players[1][player_number-1] = "ruthless"
	change_language()
