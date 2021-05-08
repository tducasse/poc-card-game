extends Area2D

var selected = false
onready var Sprite = $CollisionShape2D/Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func init(card_params):
	Sprite.texture = load(card_params.image)
	return self



func _on_Card_input_event(viewport, event, shape_idx):
	pass
