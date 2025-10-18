class_name NegotiationButton extends Button

@export_enum("REPORT", "SPLIT", "ESCAPE", "BETRAYAL", "ENFORCMENT") var resource_type: String = "REPORT"
@export var player_number: int = 1
@onready var game_session_scene: GameSessionScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_on_pressed)
	var temporary := self.get_parent().get_parent()
	if temporary is GameSessionScene:
		game_session_scene = temporary
	else:
		print("ZŁY game_session_scene W NEGOTIATION_BUTTON")

func change_language() -> void:
	text = LanguageManager.return_text("NEGOTIATION_BUTTON", resource_type)


func _on_pressed() -> void:
	print(resource_type)
	var negotiation_choice: int
	match resource_type:
		"REPORT":
			negotiation_choice = -2
		"SPLIT":
			negotiation_choice = -1
		"ESCAPE":
			negotiation_choice = 0
		"BETRAYAL":
			negotiation_choice = +1
		"ENFORCMENT":
			negotiation_choice = +2
	if player_number == 1:
		game_session_scene.p1_negotiation_choice = negotiation_choice
	else:
		game_session_scene.p2_negotiation_choice = negotiation_choice
	if game_session_scene.p1_negotiation_choice != -3 and game_session_scene.p2_negotiation_choice != -3:
		game_session_scene.emit_signal("players_have_chosen")
