extends HBoxContainer

export var opponent = false

onready var PlayerHand = $PlayerHand

onready var Deck = $Deck


func _ready():
	mouse_filter = MOUSE_FILTER_IGNORE
	if opponent:
		Deck.set_opponent()


func _on_Deck_new_card(card_params):
	PlayerHand.add_card(card_params)
