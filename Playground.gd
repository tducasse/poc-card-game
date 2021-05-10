extends CenterContainer

onready var Boards = $Boards
onready var OpponentBoard = $Boards/OpponentBoard

# Called when the node enters the scene tree for the first time.
func _ready():
	mouse_filter = MOUSE_FILTER_IGNORE
	Boards.mouse_filter = MOUSE_FILTER_IGNORE


func get_card(idx):
	return OpponentBoard.get_card(idx)
	
func get_card_slot(idx):
	return OpponentBoard.get_card_slot(idx)
