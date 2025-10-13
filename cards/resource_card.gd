extends Control

@export_enum("MONEY", "MATERIALS", "SPACE", "ENERGY", "WORKFORCE") var resource_type: String = "MONEY"
@onready var name_label := $NAME_LABEL
@onready var card_picture := $CardPicture
@onready var value_label := $VALUE_LABEL
var card_picture_folder_path: String = "res://art/cards_pictures/"
var random_value: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	name_label.text = LanguageManager.return_text("CARD_NAMES", resource_type)
	random_value = 1
	match resource_type:
		"MONEY":
			card_picture.texture = load(card_picture_folder_path.path_join("money.png"))
			random_value = int(randi() % 5 + 5)
		"MATERIALS":
			card_picture.texture = load(card_picture_folder_path.path_join("materials.png"))
			#random_value = int(randi() % 3) + 2
		"SPACE":
			card_picture.texture = load(card_picture_folder_path.path_join("space.png"))
			#random_value = int(randi() % 3) + 2
		"ENERGY":
			card_picture.texture = load(card_picture_folder_path.path_join("energy.png"))
			#random_value = int(randi() % 3) + 2
		"WORKFORCE":
			card_picture.texture = load(card_picture_folder_path.path_join("workforce.png"))
			#random_value = int(randi() % 3) + 2
	value_label.text = LanguageManager.return_text("CARD_NAMES", "VALUE") + str(random_value)

func change_language() -> void:
	name_label.text = LanguageManager.return_text("CARD_NAMES", resource_type)
	value_label.text = LanguageManager.return_text("CARD_NAMES", "VALUE") + str(random_value)
