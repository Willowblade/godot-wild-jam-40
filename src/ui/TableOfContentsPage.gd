extends Page

onready var items = $Contents/VBoxContainer/Items

onready var toc_item_scene: PackedScene = preload("res://src/ui/ToCItem.tscn")


func _ready():
	pass



func set_page_contents(contents: Dictionary):
	var i = 0
	for page in contents.pages:
		if page.type in ["creature", "introduction", "table_of_contents"]:
			var item: ToCItem = toc_item_scene.instance()
			items.add_child(item)
			item.set_number(i - 2)
			if page.type == "creature":
				if GlobalData.unlocked_creature(page.entry):
					item.set_name(page.entry.capitalize())
				else:
					item.set_name("??????")
			if page.type == "introduction":
				item.set_name("Introduction")
			if page.type == "table_of_contents":
				item.set_name("Table of Contents (this page)")
		i += 1

