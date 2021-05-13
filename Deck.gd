extends VBoxContainer

signal new_card(card_params)

onready var DeckSlot = $DeckSlot

var cards = []

func load_json_file(path):
	var file = File.new()
	file.open(path, file.READ)
	var text = file.get_as_text()
	var result_json = JSON.parse(text)
	if result_json.error != OK:
		print("[load_json_file] Error loading JSON file '" + str(path) + "'.")
		print("\tError: ", result_json.error)
		print("\tError Line: ", result_json.error_line)
		print("\tError String: ", result_json.error_string)
		return null
	var obj = result_json.result
	return obj

func _ready():
	cards = load_json_file("res://cards.json")


func make_default_card(card):
	var new_card = card.duplicate()
	new_card["current_mana"] = card.mana
	new_card["current_attack"] = card.attack
	new_card["current_hp"] = card.hp
	new_card["current_turns"] = card.max_turns
	new_card["type"] = "default"
	return new_card


func make_damage_spell(card):
	var new_card = card.duplicate()
	new_card["current_mana"] = card.mana
	new_card["current_damage"] = card.damage
	new_card["max_turns"] = 1
	new_card["current_turns"] = 1
	return new_card


func make_heal_spell(card):
	var new_card = card.duplicate()
	new_card["current_mana"] = card.mana
	new_card["current_heal"] = card.heal
	new_card["max_turns"] = 1
	new_card["current_turns"] = 1
	return new_card


func make_aoe(card):
	if card.has("damage"):
		return make_damage_spell(card)
	elif card.has("heal"):
		return make_heal_spell(card)	


func make_spell(card):
	if card.has("damage"):
		return make_damage_spell(card)
	elif card.has("heal"):
		return make_heal_spell(card)


func make_card(card):
	if not card.has("type"):
		return make_default_card(card)
	if card.type == "spell":
		return make_spell(card)
	if card.type == "aoe":
		return make_aoe(card)


func pick_random_card():
	var card = cards[randi() % cards.size()]
	var copyCard = make_card(card)
	return copyCard


func _on_DeckSlot_pick_card():
	emit_signal('new_card', pick_random_card())
	

func set_opponent():
	DeckSlot.set_opponent()
