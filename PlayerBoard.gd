extends HBoxContainer


onready var PlayerHand = $PlayerHand


func _ready():
	pass # Replace with function body.



func _on_Deck_new_card():
	PlayerHand.add_card()
