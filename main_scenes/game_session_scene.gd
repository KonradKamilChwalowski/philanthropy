extends Node2D

@onready var color_rect := $ColorRect
@onready var interface_contrainer := $InterfaceContainer
@onready var card_container := $CardContainer
@onready var resource_card_scene := preload("res://cards/resource_card.tscn")
@onready var dice_container := $DiceContainer
@onready var dice_array: Array = []
@onready var choose_card_label: Label = $DiceContainer/ChooseCardLabel
@onready var new_round_button := $NEW_ROUND_BUTTON
signal card_is_chosen(card)

var number_of_cards_to_choose: int = 0

func _ready() -> void:
	color_rect.color = GameManager.background_color
	for dice in dice_container.get_children():
		if dice is Dice:
			dice_array.append(dice)
	new_round()

func new_round() -> void:
	GameManager.current_round += 1
	change_language()
	draw_new_cards()
	throw_dices()
	if number_of_cards_to_choose > 0:
		choose_cards()

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
		card.card_id = i
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
		card.button.pressed.connect(func(): emit_signal("card_is_chosen", card), CONNECT_ONE_SHOT | CONNECT_DEFERRED)

func throw_dices() -> void:
	for dice in dice_array:
		var random_value = randi() % 6
		if random_value != 0:
			dice.label.text = str(int(random_value))
		else:
			dice.label.text = "!"
			dice.is_special = true
			number_of_cards_to_choose += 1

func choose_cards() -> void:
	choose_card_label.visible = true
	for card in card_container.get_children():
		card.button.disabled = false
	new_round_button.disabled = true
	
	var dices: Array = dice_container.get_children()
	dices.shuffle()
	for dice in dices:
		if dice is Dice:
			if dice.is_special:
				choose_card_label.text = (
					LanguageManager.return_text("GAME_SESSION_SCENE", "PLAYER_NUMBER_LABEL")
					+ str(dice.player_number)
					+ ": "
					+ LanguageManager.return_text("GAME_SESSION_SCENE", "CHOOSE_CARD_LABEL"))
				var selected_card = await card_is_chosen
				dice.label.text = str(selected_card.card_id + 1)
	
	choose_card_label.visible = false
	for card in card_container.get_children():
		card.button.disabled = true
	new_round_button.disabled = false

func _on_english_button_pressed() -> void:
	LanguageManager.set_language("eng")
	change_language()

func _on_polish_button_pressed() -> void:
	LanguageManager.set_language("pl")
	change_language()

func _on_new_round_button_pressed() -> void:
	new_round()
