extends Label

export var opponent = false
var hp = 15


func _ready():
	text = str(hp)
	if not opponent:
		var _signal = GM.connect("opponent_lose_hp", self, "lose_hp")
		var _signal2 = GM.connect("opponent_add_hp", self, "add_hp")


func lose_hp(lost):
	hp = max(hp - lost, 0)
	text = str(hp)
	if (hp <= 0):
		rpc("call_game_over", get_tree().get_network_connected_peers()[0])


remote func call_opponent_lose_hp(lost):
	GM.emit_signal("opponent_lose_hp", lost)
	
	
remote func call_opponent_add_hp(add):
	GM.emit_signal("opponent_add_hp", add)


remotesync func call_game_over(winnerID):
	GM.emit_signal("game_over", winnerID)


func add_hp(add):
	hp = hp + add
	text = str(hp)


func get_hp():
	return hp


func _on_Panel_gui_input(event):
	if (GM.turns > 0):
		if opponent:
			if event is InputEventMouseButton && event.pressed && event.button_index == BUTTON_LEFT:
				if not GM.selected_card == null && not GM.selected_card.slot.location == "hand":
					lose_hp(GM.selected_card.params.current_attack)
					GM.selected_card.lose_turn()
					rpc("call_opponent_lose_hp", GM.selected_card.params.current_attack)
					GM.emit_signal("card_unselected")
				if not GM.selected_card == null and \
				GM.selected_card.slot.location == "hand" and \
				GM.selected_card.params.type == "spell" and \
				GM.selected_card.params.has("damage"):
					lose_hp(GM.selected_card.params.current_damage)
					rpc("call_opponent_lose_hp", GM.selected_card.params.current_damage)
					GM.selected_card.remove_card()
					GM.emit_signal("card_unselected")
		else:
			if event is InputEventMouseButton && event.pressed && event.button_index == BUTTON_LEFT:
				if not GM.selected_card == null and \
				GM.selected_card.slot.location == "hand" and \
				GM.selected_card.params.type == "spell" and \
				GM.selected_card.params.has("heal"):
					add_hp(GM.selected_card.params.current_heal)
					rpc("call_opponent_add_hp", GM.selected_card.params.current_heal)
					GM.selected_card.remove_card()
					GM.emit_signal("card_unselected")
