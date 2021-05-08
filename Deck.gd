extends VBoxContainer

signal new_card


func _ready():
	pass # Replace with function body.


func _on_DeckSlot_pick_card():
	emit_signal('new_card')
