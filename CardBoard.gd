extends HBoxContainer


var location = "board"
export var opponent = false
var slots = []

# Called when the node enters the scene tree for the first time.
func _ready():
	mouse_filter = MOUSE_FILTER_IGNORE
	var children = self.get_children()
	for index in len(children):
		var slot = children[index]
		slots.append(slot)
		slot.init(index, location, opponent)


func get_card(idx):
	return slots[idx].card
	

func get_card_slot(idx):
	return slots[idx]
