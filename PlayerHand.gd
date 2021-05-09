extends HBoxContainer

var Card = preload("res://Card.tscn")

var slots = []
var opponent = false
var location = "hand"

func _ready():
	mouse_filter = MOUSE_FILTER_IGNORE
	var children = self.get_children()
	for index in len(children):
		var slot = children[index]
		slots.append(slot)
		slot.init(index, location)


func add_card(card_params):
	for i in len(slots):
		var slot = slots[i]
		if slot.is_empty():
			var card = Card.instance()
			slot.put_card(card, card_params)
			rpc("opponent_add_card", card_params, i)
			return


remote func opponent_add_card(card_params, slot_index):
	Events.emit_signal("opponent_card_picked", card_params, slot_index)


func add_opponent_card(card_params, slot_index):
	var card = Card.instance()
	var hidden = true
	slots[slot_index].put_card(card, card_params, opponent, hidden)


func set_opponent():
	opponent = true
	var _signal = Events.connect("opponent_card_picked", self, 'add_opponent_card')
	var children = self.get_children()
	for index in len(children):
		var slot = children[index]
		slot.set_opponent()


func get_card(idx):
	return slots[idx].card
	

func get_card_slot(idx):
	return slots[idx]
