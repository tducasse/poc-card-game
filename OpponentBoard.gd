extends HBoxContainer

onready var PlayerHand = $PlayerHand

onready var Deck = $Deck

func _ready():
	mouse_filter = MOUSE_FILTER_IGNORE
	Deck.set_opponent()


func opponent_add_card(card_params):
	PlayerHand.add_card(card_params)
