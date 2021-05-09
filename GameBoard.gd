extends VBoxContainer


onready var OpponentBoard = $OpponentBoard
onready var Playground = $Playground


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	mouse_filter = MOUSE_FILTER_IGNORE
	var _signal = Events.connect("opponent_move_card", self, "_on_opponent_move_card")
	
	
func find_location_node(loc):
	var location = null
	if loc == "hand":
		location = OpponentBoard
	elif loc == "board":
		location = Playground
	return location


func _on_opponent_move_card(old_loc, old_idx, new_loc, new_idx):
	var location = find_location_node(old_loc)
	var new_location = find_location_node(new_loc)
	var card_to_move = location.get_card(old_idx)
	var new_card_slot = new_location.get_card_slot(new_idx)
	
	Events.emit_signal("card_selected", card_to_move)
	new_card_slot.move_card()
