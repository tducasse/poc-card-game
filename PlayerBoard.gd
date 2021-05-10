extends HBoxContainer

onready var PlayerHand = $PlayerHand
onready var PlayerMana = $PlayerMana
onready var Deck = $Deck

export var opponent = false

func _ready():
	mouse_filter = MOUSE_FILTER_IGNORE
	if opponent:
		Deck.set_opponent()
		PlayerHand.set_opponent()
	PlayerMana.init(opponent)


func _on_Deck_new_card(card_params):
	PlayerHand.add_card(card_params)


func get_card(idx):
	return PlayerHand.get_card(idx)


func get_card_slot(idx):
	return PlayerHand.get_card_slot(idx)
