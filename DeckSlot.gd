extends MarginContainer

signal pick_card

func _ready():
	pass # Replace with function body.


func _on_Button_pressed():
	emit_signal('pick_card')
