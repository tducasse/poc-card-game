extends MarginContainer


var card = null
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func put_card(new_card, card_params):
	card = new_card
	self.add_child(card)
	card.init(card_params)


func is_empty():
	return card == null
