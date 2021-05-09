extends Area2D

var selected = false
onready var Sprite = $CollisionShape2D/Sprite
onready var Attack = $Stats/Attack
onready var Hp = $Stats/Hp
var params = null
var slot = null


signal remove_card


func init(card_params, slot_item, hidden=false, _opponent=false):
	# opponent should be used to change the color or something
	params = card_params
	slot = slot_item
	Attack.text = str(card_params.attack)
	Hp.text = str(card_params.hp)
	if hidden:
		Sprite.texture = load('res://back.png')
		Attack.hide()
		Hp.hide()
	else:
		Sprite.texture = load(card_params.image)

	return self


func get_params():
	return params


func _on_Card_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton && event.pressed && event.button_index == BUTTON_LEFT:
		Events.emit_signal("card_selected", self)


func move_card():
	emit_signal("remove_card")


func get_attack():
	return params.attack
	
	
func get_hp():
	return params.hp
	

func delete():
	queue_free()
