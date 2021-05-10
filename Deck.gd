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


func pick_random_card():
	var card = cards[randi() % cards.size()]
	card["current_attack"] = card.attack
	card["current_hp"] = card.hp
	return card


func _on_DeckSlot_pick_card():
	emit_signal('new_card', pick_random_card())
	

func set_opponent():
	DeckSlot.set_opponent()
