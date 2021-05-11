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

# warning-ignore:unused_signal
signal opponent_healed(attackerPath, attackedPath)

# warning-ignore:unused_signal
signal opponent_lose_hp(lost)

# warning-ignore:unused_signal
signal game_over()
# warning-ignore:unused_signal
signal start_game()

# warning-ignore:unused_signal
signal add_mana(add)
# warning-ignore:unused_signal
signal lose_mana(lost)
# warning-ignore:unused_signal
signal opponent_add_mana(add)
# warning-ignore:unused_signal
signal opponent_lose_mana(lost)

# warning-ignore:unused_signal
signal end_turn()
# warning-ignore:unused_signal
signal start_turn()

var mana = 0
var mana_max = 0
var opponent_mana = 0
var turns = 0

func _ready():
	var _signal = self.connect("card_selected", self, "_on_card_selected")
	var _signal2 = self.connect("card_unselected", self, "_on_card_unselected")
	var _signal3 = self.connect("end_turn", self, "_on_end_turn")
	var _signal4 = self.connect("start_game", self, "_on_start_game")
	var _signal5 = self.connect("start_turn", self, "_on_start_turn")

func _on_card_selected(card):
	if (selected_card != null):
		selected_card.modulate = Color(1,1,1)
	card.modulate = Color(0,0,1)
	selected_card = card
	
	
func _on_card_unselected():
	if (selected_card != null):
		selected_card.modulate = Color(1,1,1)
	selected_card = null


func _on_end_turn():
	emit_signal("card_unselected")
	turns = max(turns - 1, 0)
	if (turns == 0):
		rpc("call_opponent_add_turn")
	else:
		emit_signal("start_turn")


func _on_start_turn():
	mana_max = min(10, mana_max + 1)
	emit_signal("add_mana", mana_max - mana)


func add_turn():
	turns += 1


remote func call_opponent_add_turn():
	add_turn()
	emit_signal("start_turn")


func _on_start_game():
	if (get_tree().get_network_unique_id() == 1):
		add_turn()
		emit_signal("start_turn")
