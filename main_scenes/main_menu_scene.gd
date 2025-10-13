extends Node2D

@onready var buttons_container := $ButtonsContainer
@onready var game_session_settings_scene_path: String = "res://main_scenes/game_session_settings_scene.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	change_language()

func change_language() -> void:
	for btn in buttons_container.get_children():
		btn.text = LanguageManager.return_text("MAIN_MENU", btn.name)


func _on_simple_mode_button_pressed() -> void:
	get_tree().change_scene_to_file(game_session_settings_scene_path)

func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_english_button_pressed() -> void:
	LanguageManager.set_language("eng")
	change_language()

func _on_polish_button_pressed() -> void:
	LanguageManager.set_language("pl")
	change_language()
