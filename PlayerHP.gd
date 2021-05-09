extends Label

export var opponent = false
var hp = 30 


func _ready():
	text = str(hp)
	if not opponent:
		var _signal = Events.connect("opponent_lose_hp", self, "lose_hp")


func lose_hp(lost):
	hp = max(hp - lost, 0)
	text = str(hp)
	if (hp <= 0):
		rpc("call_game_over", get_tree().get_network_connected_peers()[0])


remote func call_opponent_lose_hp(lost):
	Events.emit_signal("opponent_lose_hp", lost)


remotesync func call_game_over(winnerID):
	Events.emit_signal("game_over", winnerID)


func add_hp(add):
	hp = hp + add
	text = str(hp)


func get_hp():
	return hp


func _on_Panel_gui_input(event):
	if opponent:
		if event is InputEventMouseButton && event.pressed && event.button_index == BUTTON_LEFT:
			if not Events.selected_card == null:
				lose_hp(Events.selected_card.params.current_attack)
				rpc("call_opponent_lose_hp", Events.selected_card.params.current_attack)
				Events.emit_signal("card_unselected")
