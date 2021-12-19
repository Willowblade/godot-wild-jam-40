extends Control
class_name Bestiary

onready var left_page_container = $HBoxContainer/BookContainer/PageContainer/LeftPage
onready var right_page_container = $HBoxContainer/BookContainer/PageContainer/RightPage

onready var go_right_button = $HBoxContainer/GoRightContainer/GoRightButton
onready var go_left_button = $HBoxContainer/GoLeftButtonContainer/GoLeftButton

# TODO move to global space
var known = []

var page_index = 0

var pages = [{
	"type": "empty",
}, {
	"type": "cover",
}, {
	"type": "blank",
}, {
	"type": "table_of_contents",
}, {
	"type": "author",
}, {
	"type": "introduction",
}, {
	"type": "creature",
	"creature": "chicken"
}, {
	"type": "creature",
	"creature": "octosquid"
}, {
	"type": "creature",
	"creature": "mouse"
}, {
	"type": "creature",
	"creature": "moose"
}, {
	"type": "creature",
	"creature": "molebear"
}, {
	"type": "creature",
	"creature": "sapling"
}, {
	"type": "creature",
	"creature": "unicorn"
}, {
	"type": "creature",
	"creature": "willow"
}]


func _ready():
	GlobalData.bestiary = self
#	deactivate()
	go_right_button.connect("pressed", self, "go_right")
	go_left_button.connect("pressed", self, "go_left")

	$Cancel.connect("pressed", self, "deactivate")

	SignalHub.connect("clicked_bestiary_link", self, "_on_clicked_bestiary_link")

	if len(pages) % 2 != 0:
		pages.append({
			"type": "blank",
		})
	pages.append_array([{
		"type": "cover",
	},{
		"type": "empty",
	}])

	load_pages()

	# important
	deactivate()


func _on_clicked_bestiary_link(page_number: int):
	print("Page number was clicked ", page_number)
	print("Going to index ", page_number + 2 - (page_number % 2))
	page_index = page_number + 2 - (page_number % 2)
	load_pages()


func get_page_contents(page: Dictionary):
	if page.type == "table_of_contents":
		return {
			"pages": pages,
		}
	return page

func load_pages():
	var left_page = pages[page_index]
	var right_page = pages[page_index + 1]

	print(left_page, right_page)

	left_page_container.set_page(left_page.type, get_page_contents(left_page))
	right_page_container.set_page(right_page.type, get_page_contents(right_page))

func go_right():
	AudioEngine.play_effect("page-flip")
	page_index = min(page_index + 2, len(pages) - 2)
	load_pages()

func go_left():
	AudioEngine.play_effect("page-flip")
	page_index = max(0, page_index - 2)
	load_pages()


func activate():
	AudioEngine.play_effect("book-open")
	page_index = 0
	load_pages()
	show()
	set_process(true)

func set_page(page_number):
	page_index = page_number
	load_pages()

func deactivate():
	AudioEngine.play_effect("book-close")
	hide()
	set_process(false)

func _process(delta):
	if Input.is_action_just_pressed("ui_right"):
		go_right()
	if Input.is_action_just_pressed("ui_left"):
		go_left()
	if Input.is_action_just_pressed("ui_cancel"):
		deactivate()
