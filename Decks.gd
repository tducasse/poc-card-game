extends VBoxContainer


onready var DeckList = $Main/DeckList/List
onready var CardList = $Main/CardList/List

var json = preload("res://json.gd")
const uuid_util = preload('res://uuid.gd')

var decks = []
var cards = []


func _ready():
	decks = json.load_json_file("res://decks.json")
	cards = json.load_json_file("res://cards.json")
	save_decks()
	add_decks()


func save_decks():
	for deck in decks:
		if not deck.has("uuid"):
			deck["uuid"] = uuid_util.v4()
	json.save_as_json("res://decks.json", decks)
	
	

func add_deck(deck, index):
	DeckList.add_item(deck.name)
	DeckList.set_item_metadata(index, deck)


func add_decks():
	for index in len(decks):
		var deck = decks[index]
		add_deck(deck, index)


func _on_Back_pressed():
	var lobby = load("res://Lobby.tscn")
	var root_node = get_tree().get_root()
	var decks_node = get_node("/root/Decks")
	root_node.remove_child(decks_node)
	decks_node.call_deferred("free")
	root_node.add_child(lobby.instance())


func find_card_by_uuid(uuid):
	for card in cards:
		if card.uuid == uuid:
			return card


func _on_List_item_selected(index):
	CardList.clear()
	var data = DeckList.get_item_metadata(index)
	var deck_cards = data.cards
	for card_uuid in deck_cards:
		var card = find_card_by_uuid(card_uuid)
		if not card == null:
			CardList.add_item(card.name, load(card.image))
