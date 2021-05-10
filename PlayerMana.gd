extends Label

var opponent = false


func init(opp=false):
	if opp:
		opponent=true
	update_mana()
	if opp:
		var _signal = GM.connect("opponent_lose_mana", self, "lose_mana")
		var _signal2 = GM.connect("opponent_add_mana", self, "add_mana")
	else:
		var _signal = GM.connect('lose_mana', self, "lose_mana")
		var _signal2 = GM.connect('add_mana', self, "add_mana")


func mana():
	return GM.opponent_mana if opponent else GM.mana


func change_mana(val):
	if opponent:
		GM.opponent_mana = val
	else:
		GM.mana = val


func lose_mana(lost, propagate=true):
	change_mana(max(mana() - lost, 0))
	update_mana()
	if propagate:
		rpc("on_opp_lose_mana", lost)


func add_mana(add, propagate=true):
	change_mana(mana() + add)
	update_mana()
	if propagate:
		rpc("on_opp_add_mana", add)


remote func on_opp_add_mana(add):
	GM.emit_signal("opponent_add_mana", add, false)


remote func on_opp_lose_mana(add):
	GM.emit_signal("opponent_lose_mana", add, false)


func update_mana():
	text = 'Mana - ' + str(mana())

