class_name GameSessionScene extends Node2D

@onready var color_rect := $ColorRect
@onready var interface_contrainer := $InterfaceContainer
@onready var card_container := $CardContainer
@onready var resource_card_scene := preload("res://cards/resource_card.tscn")
@onready var dice_container := $DiceContainer
@onready var dice_array: Array = []
@onready var todo_label: Label = $ToDoLabel
@onready var new_round_button := $NEW_ROUND_BUTTON
@onready var p1_button_container := $P1ButtonContainer
@onready var p2_button_container := $P2ButtonContainer

signal card_is_chosen(card)
signal players_have_chosen

var number_of_cards_to_choose: int = 0
var p1_negotiation_choice: int = -3
var p2_negotiation_choice: int = -3

func _ready() -> void:
	color_rect.color = GameManager.background_color
	for dice in dice_container.get_children():
		if dice is Dice:
			dice_array.append(dice)
	new_round()

func new_round() -> void:
	todo_label.visible = false
	GameManager.current_round += 1
	change_language()
	draw_new_cards()
	throw_dices()
	if number_of_cards_to_choose > 0:
		await choose_cards()
	check_for_negotiations()

func change_language() -> void:
	for interface in interface_contrainer.get_children():
		interface.update_resources()
	for card in card_container.get_children():
		card.change_language()
	for button in p1_button_container.get_children():
		button.change_language()
	for button in p2_button_container.get_children():
		button.change_language()
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
		dice.throw_me()
		if dice.dice_value == 0:
			number_of_cards_to_choose += 1

func choose_cards() -> void:
	todo_label.visible = true
	for card in card_container.get_children():
		card.button.disabled = false
	new_round_button.disabled = true
	
	var dices: Array = dice_container.get_children()
	dices.shuffle()
	for dice in dices:
		if dice is Dice:
			if dice.is_special:
				todo_label.text = (
					LanguageManager.return_text("GAME_SESSION_SCENE", "PLAYER_NUMBER_LABEL")
					+ str(dice.player_number)
					+ ": "
					+ LanguageManager.return_text("GAME_SESSION_SCENE", "CHOOSE_CARD_LABEL"))
				var selected_card = await card_is_chosen
				dice.label.text = str(selected_card.card_id + 1)
				dice.dice_value = str(selected_card.card_id + 1)
				dice.is_special = false
	number_of_cards_to_choose = 0
	
	todo_label.visible = false
	for card in card_container.get_children():
		card.button.disabled = true
	new_round_button.disabled = false

func check_for_negotiations() -> void:
	var cards_candidates := []
	for i in 5:
		cards_candidates.append([false,false])
	for dice in dice_array:
		cards_candidates[dice.dice_value-1][dice.player_number-1] = true
	print(cards_candidates)
	var t_card_index: int = -1
	for card in cards_candidates:
		t_card_index += 1
		if card[0] == true:
			if card[1] == true:
				pass
				#negotiate(t_card_index)
			else:
				add_resources_to_player(t_card_index, 0)
		else:
			if card[1] == true:
				add_resources_to_player(t_card_index, 1)

func negotiate(card_id: int) -> void:
	todo_label.visible = true
	todo_label.text = LanguageManager.return_text("GAME_SESSION_SCENE", "NEGOTIATION_FOR_CARD") + str(card_id + 1)
	new_round_button.disabled = true
	for button in p1_button_container.get_children():
		button.disabled = false
	for button in p2_button_container.get_children():
		button.disabled = false
	await players_have_chosen
	
	var p1_interface = interface_contrainer.get_child(0)
	var p2_interface = interface_contrainer.get_child(1)
	match p1_negotiation_choice:
		+2:
			p1_interface.slider.value += +2
			GameManager.players[2][0] += -3
			match p2_negotiation_choice:
				+2:
					p1_interface.notification_label.text += "Porażka"
				+1:
					p1_interface.notification_label.text += "Porażka"
				+0:
					p1_interface.notification_label.text += "Porażka"
				-1:
					p1_interface.notification_label.text += "Porażka"
				-2:
					p1_interface.notification_label.text += "Sukces"
					add_resources_to_player(card_id, 0)
		+1:
			p1_interface.slider.value += 1
			GameManager.players[2][0] += -3
			match p2_negotiation_choice:
				+2:
					p1_interface.notification_label.text += "Sukces"
					add_resources_to_player(card_id, 0, 0.5)
				+1:
					p1_interface.notification_label.text += "Sukces"
					add_resources_to_player(card_id, 0, 0.5)
				+0:
					p1_interface.notification_label.text += "Sukces"
					add_resources_to_player(card_id, 0, 0.5)
				-1:
					p1_interface.notification_label.text += "Porażka"
				-2:
					p1_interface.notification_label.text += "Porażka"
		+0:
			p1_interface.slider.value += 0
			p1_interface.notification_label.text += "Ucieczka"
			GameManager.p1_dice_number += 1
		-1:
			p1_interface.slider.value += -1
			GameManager.players[2][0] += -3
			match p2_negotiation_choice:
				+2:
					p1_interface.notification_label.text += "Sukces"
					add_resources_to_player(card_id, 0)
				+1:
					p1_interface.notification_label.text += "Sukces"
					add_resources_to_player(card_id, 0)
				+0:
					p1_interface.notification_label.text += "Sukces"
					add_resources_to_player(card_id, 0)
				-1:
					p1_interface.notification_label.text += "Porażka"
				-2:
					p1_interface.notification_label.text += "Porażka"
		-2:
			p1_interface.slider.value += -2
			GameManager.players[2][0] += -3
			GameManager.p1_dice_number += -1
			match p2_negotiation_choice:
				+2:
					p1_interface.notification_label.text += "Porażka"
				+1:
					p1_interface.notification_label.text += "Sukces"
					add_resources_to_player(card_id, 0)
				+0:
					p1_interface.notification_label.text += "Sukces"
					add_resources_to_player(card_id, 0)
				-1:
					p1_interface.notification_label.text += "Sukces"
					add_resources_to_player(card_id, 0)
				-2:
					p1_interface.notification_label.text += "Porażka"
	match p2_negotiation_choice:
		+2:
			p2_interface.slider.value += +2
			GameManager.players[2][1] += -3
			match p1_negotiation_choice:
				+2:
					p2_interface.notification_label.text += "Porażka"
				+1:
					p2_interface.notification_label.text += "Porażka"
				+0:
					p2_interface.notification_label.text += "Porażka"
				-1:
					p2_interface.notification_label.text += "Porażka"
				-2:
					p2_interface.notification_label.text += "Sukces"
					add_resources_to_player(card_id, 1)
		+1:
			p2_interface.slider.value += 1
			GameManager.players[2][1] += -3
			match p1_negotiation_choice:
				+2:
					p2_interface.notification_label.text += "Sukces"
					add_resources_to_player(card_id, 1, 0.5)
				+1:
					p2_interface.notification_label.text += "Sukces"
					add_resources_to_player(card_id, 1, 0.5)
				+0:
					p2_interface.notification_label.text += "Sukces"
					add_resources_to_player(card_id, 1, 0.5)
				-1:
					p2_interface.notification_label.text += "Porażka"
				-2:
					p2_interface.notification_label.text += "Porażka"
		+0:
			p2_interface.slider.value += 0
			p2_interface.notification_label.text += "Ucieczka"
			GameManager.p2_dice_number += 1
		-1:
			p2_interface.slider.value += -1
			GameManager.players[2][1] += -3
			match p1_negotiation_choice:
				+2:
					p2_interface.notification_label.text += "Sukces"
					add_resources_to_player(card_id, 2)
				+1:
					p2_interface.notification_label.text += "Sukces"
					add_resources_to_player(card_id, 2)
				+0:
					p2_interface.notification_label.text += "Sukces"
					add_resources_to_player(card_id, 2)
				-1:
					p2_interface.notification_label.text += "Porażka"
				-2:
					p2_interface.notification_label.text += "Porażka"
		-2:
			p2_interface.slider.value += -2
			GameManager.players[2][1] += -3
			GameManager.p2_dice_number += -1
			match p1_negotiation_choice:
				+2:
					p2_interface.notification_label.text += "Porażka"
				+1:
					p2_interface.notification_label.text += "Sukces"
					add_resources_to_player(card_id, 1)
				+0:
					p2_interface.notification_label.text += "Sukces"
					add_resources_to_player(card_id, 1)
				-1:
					p2_interface.notification_label.text += "Sukces"
					add_resources_to_player(card_id, 1)
				-2:
					p2_interface.notification_label.text += "Porażka"
	
	todo_label.visible = false
	new_round_button.disabled = false
	for button in p1_button_container.get_children():
		button.disabled = true
	for button in p2_button_container.get_children():
		button.disabled = true
	p1_negotiation_choice = -3
	p2_negotiation_choice = -3

func add_resources_to_player(card_id: int, player_id: int, multiplier: float = 1) -> void:
	match card_container.get_children()[card_id].resource_type:
		"MONEY":
			GameManager.players[2][player_id] += int(card_container.get_children()[card_id].random_value * multiplier)
		"MATERIALS":
			GameManager.players[3][player_id] += int(card_container.get_children()[card_id].random_value * multiplier)
		"SPACE":
			GameManager.players[4][player_id] += int(card_container.get_children()[card_id].random_value * multiplier)
		"ENERGY":
			GameManager.players[5][player_id] += int(card_container.get_children()[card_id].random_value * multiplier)
		"WORKFORCE":
			GameManager.players[6][player_id] += int(card_container.get_children()[card_id].random_value * multiplier)

func _on_english_button_pressed() -> void:
	LanguageManager.set_language("eng")
	change_language()

func _on_polish_button_pressed() -> void:
	LanguageManager.set_language("pl")
	change_language()

func _on_new_round_button_pressed() -> void:
	new_round()
	for interface in interface_contrainer.get_children():
		interface.notification_label.text = ""
