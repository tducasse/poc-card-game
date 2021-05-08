extends MarginContainer


var card = null
var Card = preload("res://Card.tscn")
onready var Panel = $Panel

func _ready():
	mouse_filter = MOUSE_FILTER_IGNORE
	

func move_card():
	var params = Events.selected_card.params
	Events.selected_card.move_card()
	var new_card = Card.instance()
	put_card(new_card, params)
	Events.emit_signal("card_unselected")


func put_card(new_card, card_params):
	card = new_card
	self.add_child(card)
	card.init(card_params)
	card.connect("remove_card", self, "_on_remove_card")
	disable_click()


func _on_remove_card():
	card.delete()
	card = null
	enable_click()


func enable_click():
	Panel.mouse_filter = MOUSE_FILTER_STOP
	

func disable_click():
	Panel.mouse_filter = MOUSE_FILTER_IGNORE


func is_empty():
	return card == null


func _on_Panel_gui_input(event):
	if event is InputEventMouseButton && event.pressed && event.button_index == BUTTON_LEFT:
		if not Events.selected_card == null:
			move_card()
