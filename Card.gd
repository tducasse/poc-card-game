extends Area2D

var selected = false
onready var Sprite = $CollisionShape2D/Sprite
onready var Attack = $Stats/Attack
onready var Hp = $Stats/Hp
var params = null
var slot = null

signal remove_card


func init(card_params, slot_item, hidden=false, opponent=false):
	# opponent should be used to change the color or something
	params = card_params
	slot = slot_item
	Attack.text = str(card_params.attack)
	Hp.text = str(card_params.current_hp)
	if (opponent):
		Events.connect("opponent_attacked", self, "get_opponent_attacked")
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
		if not slot.opponent:
			Events.emit_signal("card_selected", self)
		else:
			if Events.selected_card and not slot.location == "hand":
				rpc("opponent_attacked", Events.selected_card.get_path(), self.get_path())
				get_attacked(Events.selected_card)


func get_attacked(attacker):
	lose_hp(attacker.get_attack())
	attacker.lose_hp(params.current_attack)
	Events.emit_signal("card_unselected")


func get_opponent_attacked(attackerPath, attackedPath):
	if(get_path() == attackedPath):
		var attacker = get_node(attackerPath)
		lose_hp(attacker.get_attack())
		attacker.lose_hp(params.current_attack)


remote func opponent_attacked(attackerPath, attackedPath):
	Events.emit_signal("opponent_attacked", attackerPath, attackedPath)


func remove_card():
	emit_signal("remove_card")


func get_attack():
	return params.attack
	
	
func get_hp():
	return params.hp


func lose_hp(hits):
	params.current_hp = max(params.current_hp - hits, 0)
	Hp.text = str(params.current_hp)
	if params.current_hp == 0:
		remove_card()


func delete():
	queue_free()
