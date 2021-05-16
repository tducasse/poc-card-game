extends VBoxContainer

onready var Cards = $CardsContainer/Cards
onready var CreatePopup = $CreatePopup
var Card = preload("res://InventoryCard.tscn")

onready var Name = $CreatePopup/Container/Name
onready var Mana = $CreatePopup/Container/Mana
onready var Attack = $CreatePopup/Container/Attack
onready var Hp = $CreatePopup/Container/Hp
onready var Type = $CreatePopup/Container/Type
onready var MaxTurns = $CreatePopup/Container/MaxTurns
onready var Sprite_obj = $CreatePopup/Container/Sprite

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
	

func save_as_json(path, data):
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_line(JSON.print(data ,"  "))
	file.close()


func _ready():
	cards = load_json_file("res://cards.json")
	add_cards()
	
	
func add_card(card):
	var card_instance = Card.instance()
	Cards.add_child(card_instance)
	var _signal = card_instance.connect("edited", self, "card_edited")
	var _signal2 = card_instance.connect("deleted", self, "card_deleted")
	card_instance.init(card.duplicate())


func card_edited(old_name, new_card):
	for index in len(cards):
		var card = cards[index]
		if card.name == old_name:
			for key in card.keys():
				if new_card.has(key) and not card[key] == new_card[key]:
					card[key] = new_card[key]
			break
	save_as_json("res://cards.json", cards)
	
	
func card_deleted(old_name):
	for index in len(cards):
		var card = cards[index]
		if card.name == old_name:
			cards.remove(index)
			break
	save_as_json("res://cards.json", cards)


func add_cards():
	for card in cards:
		add_card(card)


func _on_Back_pressed():
	var lobby = load("res://Lobby.tscn")
	var root_node = get_tree().get_root()
	var inventory_node = get_node("/root/Inventory")
	root_node.remove_child(inventory_node)
	inventory_node.call_deferred("free")
	root_node.add_child(lobby.instance())


func _on_Create_pressed():
	CreatePopup.popup_centered()


func _on_CreatePopup_confirmed():
	var card = {}
	var type = Type.text.to_lower()
	if not type == '':
		card["type"] = Type.text
	if type == "spell" or type == "aoe":
		if not Attack.text == '':
			card["damage"] = int(Attack.text)
		if not Hp.text == '':
			card["heal"] = int(Hp.text)
	else:
		if not Attack.text == '':
			card["attack"] = int(Attack.text)
		if not Hp.text == '':
			card["hp"] = int(Hp.text)
	if not MaxTurns.text == '':
		card["max_turns"] = int(MaxTurns.text)
	if not Name.text == '':
		card["name"] = Name.text
	else:
		card["name"] = "No name"
	if not Sprite_obj.text == '':
		card["image"] = Sprite_obj.text.to_lower()
	else:
		card["image"] = "res://icon.png"
	if not Mana.text == '':
		card["mana"] = int(Mana.text)
	else:
		card["mana"] = 0
	cards.append(card)
	add_card(card)
	save_as_json("res://cards.json", cards)
