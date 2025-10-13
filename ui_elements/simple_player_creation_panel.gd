extends Control

@export var player_number: int = 1
@onready var hide_button := $HIDE_BUTTON
@onready var whole_container := $VBoxContainer
@onready var player_number_label := $VBoxContainer/PLAYER_NUMBER_LABEL
@onready var buttons_container := $VBoxContainer/HBoxContainer
@onready var player_character_label := $VBoxContainer/PlayerCharacterLabel


func _ready() -> void:
	change_language()

func change_language() -> void:
	hide_button.text = LanguageManager.return_text("PLAYER_CREATION_PANEL", hide_button.name)
	player_number_label.text = LanguageManager.return_text("PLAYER_CREATION_PANEL", player_number_label.name)
	for btn in buttons_container.get_children():
		btn.text = LanguageManager.return_text("PLAYER_CREATION_PANEL", btn.name)
	player_number_label.text += str(player_number)

func _on_hide_button_pressed() -> void:
	if hide_button.button_pressed:
		whole_container.visible = false
	else:
		whole_container.visible = true
	
func _on_honest_type_button_pressed() -> void:
	player_character_label.text = buttons_container.get_child(0).text

func _on_flexible_type_button_pressed() -> void:
	player_character_label.text = buttons_container.get_child(1).text

func _on_ruthless_type_button_pressed() -> void:
	player_character_label.text = buttons_container.get_child(2).text
