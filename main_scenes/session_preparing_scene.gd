extends Node2D

@onready var panels_container = $HBoxContainer
@onready var back_button = $BACK_BUTTON
@onready var next_button = $NEXT_BUTTON
@onready var game_session_settings_scene_path: String = "res://main_scenes/game_session_settings_scene.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	change_language()

func change_language() -> void:
	for panel in panels_container.get_children():
		panel.change_language()
	back_button.text = LanguageManager.return_text("GAME_SESSION_SETTINGS", back_button.name)
	next_button.text = LanguageManager.return_text("GAME_SESSION_SETTINGS", next_button.name)


func _on_english_button_pressed() -> void:
	LanguageManager.set_language("eng")
	change_language()


func _on_polish_button_pressed() -> void:
	LanguageManager.set_language("pl")
	change_language()


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file(game_session_settings_scene_path)
