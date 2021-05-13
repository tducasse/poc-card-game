extends CenterContainer

onready var Boards = $Boards
onready var OpponentBoard = $Boards/OpponentBoard
onready var PlayerBoard = $Boards/PlayerBoard

# Called when the node enters the scene tree for the first time.
func _ready():
	mouse_filter = MOUSE_FILTER_IGNORE
	Boards.mouse_filter = MOUSE_FILTER_IGNORE
	var _signal = GM.connect("cast_aoe_damage", self, "cast_aoe_damage")
	var _signal2 = GM.connect("cast_aoe_heal", self, "cast_aoe_heal")


func get_card(idx):
	return OpponentBoard.get_card(idx)
	
	
func get_card_slot(idx):
	return OpponentBoard.get_card_slot(idx)


func damage_board(board, damage):
	for card_slot in board.get_children():
		var card = card_slot.card
		if not card == null:
			card_slot.card.lose_hp(damage)
		

func heal_board(board, heal):
	for card_slot in board.get_children():
		var card = card_slot.card
		if not card == null:
			card_slot.card.add_hp(heal)


func cast_aoe_damage(damage):
	damage_board(OpponentBoard, damage)
	rpc("opponent_cast_aoe_damage", damage)
		

func cast_aoe_heal(heal):
	heal_board(PlayerBoard, heal)
	rpc("opponent_cast_aoe_heal", heal)
	

remote func opponent_cast_aoe_damage(damage):
	damage_board(PlayerBoard, damage)
	
	
remote func opponent_cast_aoe_heal(heal):
	heal_board(OpponentBoard, heal)
