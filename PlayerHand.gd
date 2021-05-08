extends HBoxContainer

var Card = preload("res://Card.tscn")

var slots = []

func _ready():
	for child in self.get_children():
		slots.append(child)


func get_empty_slots():
	var empty_slots = []
	for slot in slots:
		if slot.is_empty():
			empty_slots.append(slot)
	return empty_slots


func add_card(card_params):
	var empty_slots = get_empty_slots()
	if len(empty_slots) < 1:
		return
	var card = Card.instance()
	empty_slots[0].put_card(card, card_params)
