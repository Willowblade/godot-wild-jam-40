extends Node


signal clicked_bestiary_link(number)


func _ready():
	pass

func on_clicked_bestiary_link(page_number):
	print("Clicked ", page_number)
	emit_signal("clicked_bestiary_link", page_number)
