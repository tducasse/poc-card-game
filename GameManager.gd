extends Node2D


enum LOCATION {
	HAND,
	BOARD
}

enum PLAYERS {
	SELF,
	OTHER
}

var cards = []


func _ready():
	pass # Replace with function body.


func register_card(card, location, player):
	cards.append({"card": card, "location": location, "player": player})
