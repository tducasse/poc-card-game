extends VBoxContainer

signal new_card(card_params)

onready var DeckSlot = $DeckSlot


func pick_random_card():
	# this should pick a random card
	var atk = randi() % 8 + 1
	var hp = randi() % 10 + 3
	var mana = 1
	var image = "res://icon.png"
	return {
		"image": image,
		"attack": atk,
		"hp": hp,
		"current_attack": atk,
		"current_hp": hp,
		"mana": mana
	}


func _on_DeckSlot_pick_card():
	emit_signal('new_card', pick_random_card())
	

func set_opponent():
	DeckSlot.set_opponent()
