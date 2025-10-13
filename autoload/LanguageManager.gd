extends Node

var ui_localization_path: String = "res://data/ui_localization.json"
var translations: Dictionary = {}   # {"en": {...}, "pl": {...}}
var current_language: String = "eng"


func _ready() -> void:
	load_localization_file()
	print("[LanguageManager] Loaded languages: ", translations.keys())
	print("[LanguageManager] Current language: ", current_language)


func set_language(new_language: String) -> void:
	if not translations.has(new_language):
		push_warning("Language '%s' not found in translations" % new_language)
		return
	current_language = new_language


func return_text(scene_key: String, text_key: String) -> String:
	var key: String = scene_key + "." + text_key
	return translations.get(current_language, {}).get(key, key)


func load_localization_file() -> void:
	if not FileAccess.file_exists(ui_localization_path):
		push_error("Localization file not found: %s" % ui_localization_path)
		return
	
	var file := FileAccess.open(ui_localization_path, FileAccess.READ)
	if file == null:
		push_error("Failed to open localization file: %s" % ui_localization_path)
		return
	
	var content := file.get_as_text()
	var result = JSON.parse_string(content)
	if typeof(result) != TYPE_DICTIONARY:
		push_error("Localization JSON has invalid structure.")
		return
	translations = result
