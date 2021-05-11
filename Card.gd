extends Area2D

var selected = false
onready var Sprite = $CollisionShape2D/Sprite
onready var Attack = $Stats/Attack
onready var Hp = $Stats/Hp
onready var Mana = $Mana
onready var Info = $Info
onready var Name = $Name
var params = null
var slot = null

signal remove_card


func init(card_params, slot_item, hidden=false, _opponent=false):
	var _st_status = GM.connect("start_turn", self, "_on_start_turn")
	# opponent should be used to change the color or something
	params = card_params
	slot = slot_item
	if card_params.type == "default":
		Attack.text = str(card_params.attack)
		Hp.text = str(card_params.current_hp)
	elif card_params.type == "spell":
		if card_params.has("damage"):
			Attack.text = str(card_params.damage)
			Hp.hide()
		if card_params.has("heal"):
			Hp.text = str(card_params.heal)
			Attack.hide()
	Mana.text = str(card_params.current_mana)
	Name.text = str(card_params.name)
	if hidden:
		Sprite.texture = load('res://back.png')
		Attack.hide()
		Hp.hide()
		Mana.hide()
		Name.hide()
	else:
		Sprite.texture = load(card_params.image)
	init_info()
	return self


func init_info():
	var info_text = ''
	for key in params.keys():
		if not key.begins_with("current"):
			info_text = info_text + key + ": " + str(params[key]) + '\n\n'
	Info.dialog_text = info_text
	var font = load("res://Bebas.tres")
	Info.get_label().add_font_override('font', font)


func get_params():
	return params


func _on_Card_input_event(_viewport, event, _shape_idx):
	if (GM.turns > 0) :
		if event is InputEventMouseButton && event.pressed && event.button_index == BUTTON_LEFT:
			if not slot.opponent:
				if GM.selected_card and \
				GM.selected_card.params.type == "spell" and \
				GM.selected_card.params.has("heal") and \
				not slot.location == "hand":
					GM.emit_signal("opponent_healed", GM.selected_card.get_path(), self.get_path())
					get_healed(GM.selected_card)
				elif params.current_turns > 0:
					GM.emit_signal("card_selected", self)
			else:
				if GM.selected_card and \
				not slot.location == "hand" and \
				(not GM.selected_card.slot.location == "hand" or GM.selected_card.params.type == "spell") and \
				GM.selected_card.params.current_turns > 0:
					GM.emit_signal("opponent_attacked", GM.selected_card.get_path(), self.get_path())
					get_attacked(GM.selected_card)
		if event is InputEventMouseButton && event.pressed && event.doubleclick && event.button_index == BUTTON_LEFT:
			if not slot.opponent or not slot.location == "hand":
				GM.emit_signal("card_unselected")
				Info.popup_centered()


func get_attacked(attacker):
	if attacker.params.type == "default":
		attacker.lose_turn()
		attacker.lose_hp(params.current_attack)
		lose_hp(attacker.get_attack())
	elif attacker.params.type == "spell":
		if attacker.params.has("damage"):
			lose_hp(attacker.params.current_damage)
			attacker.remove_card()
	GM.emit_signal("card_unselected")
	

func get_opponent_attacked(attacker_path, defender_path):
	if(get_path() == defender_path):
		var attacker = get_node(attacker_path)
		if attacker.params.type == "default":
			lose_hp(attacker.get_attack())
			attacker.lose_hp(params.current_attack)
		elif attacker.params.type == "spell":
			if attacker.params.has("damage"):
				lose_hp(attacker.params.current_damage)
				attacker.remove_card()


func get_healed(healer):
	add_hp(healer.params.current_heal)
	healer.remove_card()
	GM.emit_signal("card_unselected")
	

func get_opponent_healed(healer_path, healed_path):
	if(get_path() == healed_path):
		var healer = get_node(healer_path)
		add_hp(healer.params.current_heal)
		healer.remove_card()


func remove_card():
	emit_signal("remove_card")


func get_attack():
	return params.attack
	
	
func get_hp():
	return params.hp
	
	
func add_hp(add):
	params.current_hp = min(params.current_hp + add, params.hp)
	Hp.text = str(params.current_hp)


func lose_hp(hits):
	params.current_hp = max(params.current_hp - hits, 0)
	Hp.text = str(params.current_hp)
	if params.current_hp == 0:
		remove_card()

func lose_turn():
	params.current_turns = max(0, params.current_turns - 1)
	if (params.current_turns == 0):
		Sprite.modulate = Color(1,0,0)


func delete():
	queue_free()


func _on_start_turn():
	params.current_turns = params.max_turns
	Sprite.modulate = Color(1,1,1)
