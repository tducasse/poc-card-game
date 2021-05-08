extends HBoxContainer

onready var PlayerHand = $PlayerHand

onready var Deck = $Deck


func _ready():
	mouse_filter = MOUSE_FILTER_IGNORE


func _on_Deck_new_card(card_params):
	PlayerHand.add_card(card_params)
	rpc('opponent_add_card', card_params)


# ET DIRE QUE J'AI PASSE 4 ANS A METTRE DES SIGNAUX PARTOUT ET CA MARCHE PAS, A REWORK IUZGEFDSJGFSVGHSDVFHSQFDJBGSEFHVJ
remote func opponent_add_card(card_params):
	get_node("/root/GameBoard/OpponentBoard").opponent_add_card(card_params)
