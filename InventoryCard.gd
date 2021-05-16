extends MarginContainer


onready var Sprite_obj = $OuterContainer/Container/Sprite
onready var Name = $OuterContainer/Container/TopContainer/TopRow/Name
onready var Mana = $OuterContainer/Container/TopContainer/TopRow/Mana
onready var Attack = $OuterContainer/Container/BottomContainer/BottomRow/Attack
onready var Hp = $OuterContainer/Container/BottomContainer/BottomRow/Hp
onready var MaxTurns = $OuterContainer/Container/MarginContainer/MaxTurns
onready var EditPopup = $EditPopup
onready var SpritePopup = $EditPopup/Container/Sprite
onready var NamePopup = $EditPopup/Container/Name
onready var ManaPopup = $EditPopup/Container/Mana
onready var AttackPopup = $EditPopup/Container/Attack
onready var AttackLabel = $EditPopup/Container/AttackLabel
onready var HpLabel = $EditPopup/Container/HpLabel
onready var HpPopup = $EditPopup/Container/Hp
onready var MaxTurnsPopup = $EditPopup/Container/MaxTurns
onready var MaxTurnsLabel = $EditPopup/Container/MaxTurnsLabel

signal edited(old_name, new_card)
signal deleted(old_name)

var card = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func init(params):
	card = params
	Sprite_obj.texture = load(params.image)
	Name.text = str(params.name)
	Mana.text = str(params.mana)
	if params.has("attack"):
		Attack.text = str(params.attack)
	elif params.has("damage"):
		Attack.text = str(params.damage)
	else:
		Attack.hide()
	if params.has("hp"):
		Hp.text = str(params.hp)
	elif params.has("heal"):
		Hp.text = str(params.heal)
	else:
		Hp.hide()
	if params.has("max_turns"):
		MaxTurns.text = "Turns: " + str(params.max_turns)
	else:
		MaxTurns.hide()
	EditPopup.add_button("Delete", true, "delete_pressed")


func delete_card():
	emit_signal("deleted", card.name)
	queue_free()


func _on_InventoryCard_gui_input(event):
	if event is InputEventMouseButton && event.pressed && event.doubleclick && event.button_index == BUTTON_LEFT:
		SpritePopup.text = str(card.image)
		NamePopup.text = str(card.name)
		ManaPopup.text = str(card.mana)
		if card.has("attack"):
			AttackPopup.text = str(card.attack)
		elif card.has("damage"):
			AttackPopup.text = str(card.damage)
		else:
			AttackLabel.hide()
			AttackPopup.hide()
		if card.has("hp"):
			HpPopup.text = str(card.hp)
		elif card.has("heal"):
			HpPopup.text = str(card.heal)
		else:
			HpLabel.hide()		
			HpPopup.hide()
		if card.has("max_turns"):
			MaxTurnsPopup.text = str(card.max_turns)
		else:
			MaxTurnsLabel.hide()			
			MaxTurnsPopup.hide()
		EditPopup.popup_centered()


func _on_EditPopup_confirmed():
	var new_card = {
		"name": NamePopup.text,
		"mana": int(ManaPopup.text),
		"image": SpritePopup.text.to_lower()
	}
	if card.has("max_turns"):
		new_card["max_turns"] = int(MaxTurnsPopup.text)
	if card.has("attack"):
		new_card["attack"] = int(AttackPopup.text)
	if card.has("damage"):
		new_card["damage"] = int(AttackPopup.text)
	if card.has("hp"):
		new_card["hp"] = int(HpPopup.text)
	if card.has("heal"):
		new_card["heal"] = int(HpPopup.text)
	var old_name = card.name
	init(new_card)
	emit_signal("edited", old_name, new_card)


func _on_EditPopup_custom_action(action):
	if action == "delete_pressed":
		delete_card()
		EditPopup.hide()
