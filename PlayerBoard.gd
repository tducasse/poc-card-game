extends HBoxContainer

onready var PlayerHand = $PlayerHand
onready var PlayerMana = $PlayerData/PlayerMana
onready var EndTurn = $PlayerData/EndTurn
onready var Deck = $Deck


export var opponent = false

func _ready():
	mouse_filter = MOUSE_FILTER_IGNORE
	if opponent:
		Deck.set_opponent()
		PlayerHand.set_opponent()
		EndTurn.hide()
	PlayerMana.init(opponent)
	EndTurn.set_text("End turn " + str(GM.turns))
	var _st_status = GM.connect("start_turn", self, "_on_start_turn")
	var _et_status = GM.connect("end_turn", self, "_on_end_turn")


func _on_Deck_new_card(card_params):
	PlayerHand.add_card(card_params)


func get_card(idx):
	return PlayerHand.get_card(idx)


func get_card_slot(idx):
	return PlayerHand.get_card_slot(idx)


func _on_start_turn():
	EndTurn.set_text("End turn " + str(GM.turns))
	if (not opponent):
		EndTurn.visible = true


func _on_end_turn():
	EndTurn.set_text("End turn " + str(GM.turns))
	if (not opponent):
		EndTurn.visible = false


func _on_EndTurn_pressed():
	GM.emit_signal("end_turn")
