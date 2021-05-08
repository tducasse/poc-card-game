extends Area2D

var selected = false
onready var Sprite = $CollisionShape2D/Sprite
var params = null

signal remove_card


func init(card_params):
	params = card_params
	Sprite.texture = load(card_params.image)
	return self


func get_params():
	return params


func _on_Card_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton && event.pressed && event.button_index == BUTTON_LEFT:
		Events.emit_signal("card_selected", self)


func move_card():
	emit_signal("remove_card")


func delete():
	queue_free()
