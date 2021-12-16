extends Node2D

onready var pillows = {
	"basic": {
		"front": preload("res://assets/objects/nest/nest-front.png"),
		"back": preload("res://assets/objects/nest/nest-back.png"),
	},
	"pillow": {
		"front": preload("res://assets/objects/nest/royal-pillow-front.png"),
		"back": preload("res://assets/objects/nest/royal-pillow-back.png"),
	}
}

func set_basic_nest():
	$Front.position = Vector2()
	$Back.position = Vector2()
	$Front.texture = pillows.basic.front
	$Back.texture = pillows.basic.back

func set_luxury_cushion():
	$Front.position = Vector2(0, 3)
	$Back.position = Vector2(0, 3)
	$Front.texture = pillows.pillow.front
	$Back.texture = pillows.pillow.back


func _ready():
	set_luxury_cushion()


