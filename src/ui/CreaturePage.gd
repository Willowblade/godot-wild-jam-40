extends Page

onready var title = $Contents/VBoxContainer/Title
onready var egg_picture = $Contents/VBoxContainer/HBoxContainer/EggPicture
onready var creature_picture = $Contents/VBoxContainer/HBoxContainer/CreaturePicture
onready var description = $Contents/VBoxContainer/Description

onready var unknown_texture = preload("res://assets/book/unknown-image.png")

func load_creature(creature_name):
	if creature_name in GlobalData.known:
		var creature_data = Database.BESTIARY[creature_name]
		title.text = creature_data.name
		description.text = creature_data.description
		creature_picture.texture = creature_data.creature
		egg_picture.texture = creature_data.egg
	else:
		title.text = "????"
		description.text = "?????"
		creature_picture.texture = unknown_texture
		egg_picture.texture = unknown_texture

func set_page_contents(contents: Dictionary):
	load_creature(contents.creature)
