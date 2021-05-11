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
	return {
			"name": card.name,
			"attack": card.attack,
			"hp": card.hp,
			"image": card.image,
			"mana": card.mana,
			"current_attack": card.attack,
			"current_hp": card.hp,
			"current_mana": card.mana,
			"max_turns": card.max_turns,
			"current_turns": card.max_turns,
			"type": "default"
		}


func make_damage_spell(card):
	return {
			"name": card.name,
			"image": card.image,
			"mana": card.mana,
			"current_mana": card.mana,
			"damage": card.damage,
			"current_damage": card.damage,
			"type": card.type,
			"max_turns": 1,
			"current_turns": 1,
		}
		
func make_heal_spell(card):
	return {
			"name": card.name,
			"image": card.image,
			"mana": card.mana,
			"current_mana": card.mana,
			"heal": card.heal,
			"current_heal": card.heal,
			"type": card.type,
			"max_turns": 1,
			"current_turns": 1,
		}


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


func pick_random_card():
	var card = cards[randi() % cards.size()]
	var copyCard = make_card(card)
	return copyCard


func _on_DeckSlot_pick_card():
	emit_signal('new_card', pick_random_card())
	

func set_opponent():
	DeckSlot.set_opponent()
