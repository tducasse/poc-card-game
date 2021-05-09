extends VBoxContainer

signal new_card(card_params)

onready var DeckSlot = $DeckSlot


func pick_random_card():
	# this should pick a random card
	return {
		"image": "res://icon.png",
		"attack": randi() % 10 + 1,
		"hp": randi() % 10 + 1,
	}


func _on_DeckSlot_pick_card():
	emit_signal('new_card', pick_random_card())
	

func set_opponent():
	DeckSlot.set_opponent()
