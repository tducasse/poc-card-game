extends Label

export var opponent = false
var hp = 30 


func _ready():
	text = str(hp)


func lose_hp(lost):
	hp = max(hp - lost, 0)


func add_hp(add):
	hp = hp + add


func get_hp():
	return hp
