extends Node

# clicked on a card
# warning-ignore:unused_signal
signal card_selected(card)
# warning-ignore:unused_signal
signal card_unselected()
var selected_card = null

# warning-ignore:unused_signal
signal opponent_card_picked(card_params, slot_index)

# warning-ignore:unused_signal
signal opponent_move_card(old_loc, old_idx, new_loc, new_idx)

# warning-ignore:unused_signal
signal opponent_attacked(attackerPath, attackedPath)


func _ready():
	var _signal = self.connect("card_selected", self, "_on_card_selected")
	var _signal2 = self.connect("card_unselected", self, "_on_card_unselected")
	

func _on_card_selected(card):
	if (selected_card != null):
		selected_card.modulate = Color(1,1,1)
	card.modulate = Color(0,0,1)
	selected_card = card
	
	
func _on_card_unselected():
	if (selected_card != null):
		selected_card.modulate = Color(1,1,1)
	selected_card = null
