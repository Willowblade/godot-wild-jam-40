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
	"type": "blank",
}, {
	"type": "introduction",
}, {
	"type": "creature",
	"entry": "chicken"
}, {
	"type": "creature",
	"entry": "chicken"
}, {
	"type": "creature",
	"entry": "chicken"
}, {
	"type": "creature",
	"entry": "chicken"
}]



func _ready():
	GlobalData.bestiary = self
#	deactivate()
	go_right_button.connect("pressed", self, "go_right")
	go_left_button.connect("pressed", self, "go_left")

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
	page_index = min(page_index + 2, len(pages) - 2)
	load_pages()

func go_left():
	page_index = max(0, page_index - 2)
	load_pages()


func activate():
	show()
	set_process(true)

func deactivate():
	hide()
	set_process(false)

func _process(delta):
	if Input.is_action_just_pressed("ui_right"):
		go_right()
	if Input.is_action_just_pressed("ui_left"):
		go_left()
