extends MarginContainer

signal pick_card

onready var PickCard = $Panel/PickCard

func _ready():
	pass # Replace with function body.


func _on_Button_pressed():
	emit_signal('pick_card')


func set_opponent():
	PickCard.hide()
