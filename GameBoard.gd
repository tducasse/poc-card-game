extends VBoxContainer


onready var OpponentBoard = $OpponentBoard
onready var Playground = $Playground
onready var popup = $Popup

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	mouse_filter = MOUSE_FILTER_IGNORE
	var _signal = Events.connect("opponent_move_card", self, "_on_opponent_move_card")
	var _go_status = Events.connect("game_over", self, "_on_game_over")
	
	
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
	var hidden = new_loc == "hand"
	new_card_slot.move_card(hidden)


func _on_game_over(winnerID):
	popup.dialog_text = "Player%d won !" % [winnerID]
	popup.popup_centered()


func _on_Popup_popup_hide():
	get_tree().network_peer = null
	var lobby = load("res://Lobby.tscn")
	var root_node = get_tree().get_root()
	var gameboard_node = get_node("/root/GameBoard")
	root_node.remove_child(gameboard_node)
	gameboard_node.call_deferred("free")
	root_node.add_child(lobby.instance())
