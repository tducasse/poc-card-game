extends VBoxContainer

onready var Cards = $CardsContainer/Cards
var Card = preload("res://InventoryCard.tscn")

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
	add_cards()
	
	
func add_card(card):
	var card_instance = Card.instance()
	Cards.add_child(card_instance)
	card_instance.init(card)


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
