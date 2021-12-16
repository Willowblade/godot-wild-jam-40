extends Control
class_name Page

export(String, "EMPTY", "COVER", "PAGE") var type: String = "EMPTY"

onready var empty_page_texture = preload("res://assets/book/empty.png")
onready var left_page_texture = preload("res://assets/book/page-left.png")
onready var right_page_texture = preload("res://assets/book/page-right.png")
onready var cover_front_texture = preload("res://assets/book/cover-front.png")
onready var cover_back_texture = preload("res://assets/book/cover-back.png")

var side = "left"

func _ready():
	set_page_texture()


func set_page_margins():
	if side == "left":
		$Contents.add_constant_override("margin_left", 90)
		$Contents.add_constant_override("margin_right", 50)
	if side == "right":
		$Contents.add_constant_override("margin_left", 35)
		$Contents.add_constant_override("margin_right", 100)

func set_page_texture():
	set_page_margins()

	if type == "EMPTY":
		$PageTexture.texture = empty_page_texture
	elif type == "COVER":
		if side == "left":
			$PageTexture.texture = cover_back_texture
		elif side == "right":
			$PageTexture.texture = cover_front_texture
	elif type == "PAGE":
		if side == "left":
			$PageTexture.texture = left_page_texture
		elif side == "right":
			$PageTexture.texture = right_page_texture


func set_page_contents(contents: Dictionary):
	pass
