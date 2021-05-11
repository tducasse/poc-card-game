extends MarginContainer


var card = null
var Card = preload("res://Card.tscn")
onready var Panel = $Panel
var index = null
var location = null
var opponent = false

func _ready():
	mouse_filter = MOUSE_FILTER_IGNORE

func init(idx, loc, opp = false):
	index = idx
	location = loc
	opponent = opp
	if (opponent):
		disable_click()


func move_card(hidden=false):
	var params = GM.selected_card.params
	if location == "board" && GM.selected_card.params.type == "spell":
		return
	if location == "board" && GM.selected_card.slot.location == "hand" && not opponent:
		if GM.mana >= params.current_mana:
			GM.emit_signal("lose_mana", params.current_mana)
		else:
			GM.emit_signal("card_unselected")
			return
	if not opponent:
		rpc("opponent_move_card", GM.selected_card.slot.location, GM.selected_card.slot.index, location, index)
	GM.selected_card.remove_card()
	var new_card = Card.instance()
	put_card(new_card, params, false,  hidden)
	GM.emit_signal("card_unselected")


func put_card(new_card, card_params, _opponent=false, hidden=false):
	card = new_card
	self.add_child(card)
	card.init(card_params, self, hidden, opponent)
	card.connect("remove_card", self, "_on_remove_card")
	disable_click()


func _on_remove_card():
	card.delete()
	card = null
	if (not opponent):
		enable_click()


func enable_click():
	Panel.mouse_filter = MOUSE_FILTER_STOP
	

func disable_click():
	Panel.mouse_filter = MOUSE_FILTER_IGNORE


func is_empty():
	return card == null
	

func set_opponent():
	opponent = true
	disable_click()


func _on_Panel_gui_input(event):
	if (GM.turns > 0):
		if event is InputEventMouseButton && event.pressed && event.button_index == BUTTON_LEFT:
			if not GM.selected_card == null:
				move_card()
		elif event is InputEventMouseButton && event.pressed && event.button_index == BUTTON_RIGHT:
			GM.emit_signal("card_unselected")


remote func opponent_move_card(old_loc, old_idx, new_loc, new_idx):
	GM.emit_signal("opponent_move_card", old_loc, old_idx, new_loc, new_idx)
