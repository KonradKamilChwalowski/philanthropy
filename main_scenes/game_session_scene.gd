extends Node2D

@onready var color_rect := $ColorRect
@onready var interface_contrainer := $InterfaceContainer
@onready var card_container := $CardContainer
@onready var resource_card_scene := preload("res://cards/resource_card.tscn")
@onready var dice_container := $DiceContainer
@onready var dice_array: Array = []
@onready var new_round_button := $NEW_ROUND_BUTTON

func _ready() -> void:
	color_rect.color = GameManager.background_color
	for dice in dice_container.get_children():
		dice_array.append(dice)
	new_round()

func change_language() -> void:
	for interface in interface_contrainer.get_children():
		interface.update_resources()
	for card in card_container.get_children():
		card.change_language()
	new_round_button.text = LanguageManager.return_text("GAME_SESSION_SCENE", "NEW_ROUND_BUTTON")
	new_round_button.text += str(GameManager.current_round)

func draw_new_cards() -> void:
	for child in card_container.get_children():
		child.queue_free()
	
	for i in 5:
		var card = resource_card_scene.instantiate()
		var random_type_id = randi() % 5
		match random_type_id:
			0:
				card.resource_type = "MONEY"
			1:
				card.resource_type = "MATERIALS"
			2:
				card.resource_type = "SPACE"
			3:
				card.resource_type = "ENERGY"
			4:
				card.resource_type = "WORKFORCE"
		card_container.add_child(card)

func throw_dices() -> void:
	for dice in dice_array:
		var random_value = randi() % 6
		if random_value != 0:
			dice.label.text = str(int(random_value))
		else:
			dice.label.text = "!"

func new_round() -> void:
	GameManager.current_round += 1
	change_language()
	draw_new_cards()
	throw_dices()

func _on_english_button_pressed() -> void:
	LanguageManager.set_language("eng")
	change_language()

func _on_polish_button_pressed() -> void:
	LanguageManager.set_language("pl")
	change_language()

func _on_new_round_button_pressed() -> void:
	new_round()
