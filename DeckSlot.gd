extends MarginContainer

signal pick_card

onready var PickCard = $Panel/PickCard

var opponent = false

func _ready():
	var _st_status = GM.connect("start_turn", self, "_on_start_turn")
	var _et_status = GM.connect("end_turn", self, "_on_end_turn")


func _on_Button_pressed():
	emit_signal('pick_card')
	PickCard.hide()


func set_opponent():
	opponent = true


func _on_start_turn():
	if (not opponent):
		PickCard.show()


func _on_end_turn():
	if (not opponent):
		PickCard.hide()
