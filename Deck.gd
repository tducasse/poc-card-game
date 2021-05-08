extends VBoxContainer

signal new_card(card_params)

onready var DeckSlot = $DeckSlot

func _ready():
	pass # Replace with function body.


func pick_random_card():
	# this should pick a random card
	return {
		"image": "res://icon.png"
	}


func _on_DeckSlot_pick_card():
	emit_signal('new_card', pick_random_card())
	

func set_opponent():
	DeckSlot.set_opponent()
