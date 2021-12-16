extends Node2D

onready var nest = $Nest
onready var placeholder = $NestPlaceholder

export(String, "NEST", "PILLOW") var base_type = "NEST"

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


func show_placeholder():
	placeholder.show()

func hide_placeholder():
	placeholder.hide()

func set_textures(back, front):
	$Nest/Back.texture = back
	$Nest/Front.texture = front
	$Nest.reset()
	$NestPlaceholder/Back.texture = back
	$NestPlaceholder/Front.texture = front

func set_pillow():
	set_textures(pillows.pillow.back, pillows.pillow.front)

func set_nest():
	set_textures(pillows.basic.back, pillows.basic.front)

func _ready():
	if base_type == "NEST":
		set_nest()
	if base_type == "PILLOW":
		set_pillow()
