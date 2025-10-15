extends Node2D

@onready var color_rect := $ColorRect
@onready var settings_container = $SettingsContainer
@onready var players_number_label = $SettingsContainer/PLAYERS_NUMBER_LABEL
@onready var back_button = $BACK_BUTTON
@onready var next_button = $NEXT_BUTTON

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	color_rect.color = GameManager.background_color
	change_language()

func change_language() -> void:
	for child in settings_container.get_children():
		if child.has_method("set_text"):
			child.text = LanguageManager.return_text("GAME_SESSION_SETTINGS", child.name)
	back_button.text = LanguageManager.return_text("GAME_SESSION_SETTINGS", back_button.name)
	next_button.text = LanguageManager.return_text("GAME_SESSION_SETTINGS", next_button.name)


func _on_players_number_slider_value_changed(value: float) -> void:
	change_language()
	players_number_label.text += str(int(value))


func _on_english_button_pressed() -> void:
	LanguageManager.set_language("eng")
	change_language()

func _on_polish_button_pressed() -> void:
	LanguageManager.set_language("pl")
	change_language()


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file(GameManager.main_menu_scene_path)

func _on_next_button_pressed() -> void:
	get_tree().change_scene_to_file(GameManager.session_preparing_scene_path)
