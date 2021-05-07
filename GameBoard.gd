extends Control


onready var container4 = $MyBoard/Hand/MarginContainer4
var card_sprite = preload("res://icon.png")


# C'EST DE LA MERDE CE SYSTEME, J'AI X MarginContainer AU LIEU D'UN CONTAINER QUI SPACE TOUT BIEN, A REWORK
# PEUT-ÊTRE GRID CONTAINER ?


func _on_Button_pressed():
	var card = Sprite.new()
	card.set_texture(card_sprite)
	container4.add_child(card)
	pass # Replace with function body.
