extends VBoxContainer

onready var Cards = $CardsContainer/Cards
onready var CreatePopup = $CreatePopup
var Card = preload("res://InventoryCard.tscn")
const uuid_util = preload('res://uuid.gd')
var json = preload("res://json.gd")

onready var Name = $CreatePopup/Container/Name
onready var Mana = $CreatePopup/Container/Mana
onready var Attack = $CreatePopup/Container/Attack
onready var Hp = $CreatePopup/Container/Hp
onready var Type = $CreatePopup/Container/Type
onready var MaxTurns = $CreatePopup/Container/MaxTurns
onready var Sprite_obj = $CreatePopup/Container/Sprite


var cards = []

func save_cards():
	for card in cards:
		if not card.has('uuid'):
			card["uuid"] = uuid_util.v4()
	json.save_as_json("res://cards.json", cards)


func _ready():
	cards = json.load_json_file("res://cards.json")
	save_cards()
	add_cards()
	
	
func add_card(card):
	var card_instance = Card.instance()
	Cards.add_child(card_instance)
	var _signal = card_instance.connect("edited", self, "card_edited")
	var _signal2 = card_instance.connect("deleted", self, "card_deleted")
	card_instance.init(card.duplicate())


func card_edited(new_card):
	for index in len(cards):
		var card = cards[index]
		if card.uuid == new_card.uuid:
			for key in card.keys():
				if new_card.has(key) and not card[key] == new_card[key]:
					card[key] = new_card[key]
			break
	save_cards()
	
	
func card_deleted(uuid):
	for index in len(cards):
		var card = cards[index]
		if card.uuid == uuid:
			cards.remove(index)
			break
	save_cards()


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
	card["uuid"] = uuid_util.v4()
	cards.append(card)
	add_card(card)
	save_cards()
