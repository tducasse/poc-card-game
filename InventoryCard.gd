extends MarginContainer


onready var Sprite = $OuterContainer/Container/Sprite
onready var Name = $OuterContainer/Container/TopContainer/TopRow/Name
onready var Mana = $OuterContainer/Container/TopContainer/TopRow/Mana
onready var Attack = $OuterContainer/Container/BottomContainer/BottomRow/Attack
onready var Hp = $OuterContainer/Container/BottomContainer/BottomRow/Hp


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func init(params):
	Sprite.texture = load(params.image)
	Name.text = str(params.name)
	Mana.text = str(params.mana)
	if params.has("attack"):
		Attack.text = str(params.attack)
	if params.has("damage"):
		Attack.text = str(params.damage)
	if params.has("hp"):
		Hp.text = str(params.hp)
	if params.has("heal"):
		Hp.text = str(params.heal)
