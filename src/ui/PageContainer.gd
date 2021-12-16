extends Control


onready var empty_page_scene = preload("res://src/ui/EmptyPage.tscn")
onready var blank_page_scene = preload("res://src/ui/BlankPage.tscn")
onready var cover_page_scene = preload("res://src/ui/CoverPage.tscn")
onready var introduction_page_scene = preload("res://src/ui/IntroductionPage.tscn")
onready var creature_page_scene = preload("res://src/ui/CreaturePage.tscn")
onready var toc_scene = preload("res://src/ui/TableOfContentsPage.tscn")

onready var contents_container = $Contents

var page: Page = null

export var side = "LEFT"

onready var mapping  = {
	"blank": blank_page_scene,
	"cover": cover_page_scene,
	"empty": empty_page_scene,
	"introduction": introduction_page_scene,
	"creature": creature_page_scene,
	"table_of_contents": toc_scene,
}

func _ready():
	pass

func set_page(page_type: String, contents: Dictionary):
	if page:
		contents_container.remove_child(page)
		page.queue_free()
	print(page_type, mapping[page_type])
	load_page(mapping[page_type], contents)

func load_page(page_scene: PackedScene, contents: Dictionary):
	page = page_scene.instance()
	page.side = side.to_lower()
	contents_container.add_child(page)
	page.set_page_contents(contents)
