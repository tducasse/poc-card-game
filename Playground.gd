extends CenterContainer


onready var Container = $Container
onready var OpponentBoard = $Container/OpponentBoard

# Called when the node enters the scene tree for the first time.
func _ready():
	mouse_filter = MOUSE_FILTER_IGNORE
	Container.mouse_filter = MOUSE_FILTER_IGNORE


func get_card(idx):
	return OpponentBoard.get_card(idx)
	
func get_card_slot(idx):
	return OpponentBoard.get_card_slot(idx)
