extends ClickableTexture
class_name Egg

onready var sprite = $Graphics/Sprite
onready var notification = $Graphics/Notification

export var static_egg = false

export var growth_rate = 1.0
export var type = "chicken"


export var wiggle_time = 10.0
export var wiggle_variation = 1.0


# TODO we can move the logic to the incubator actually
var humidity_requirement = 60
var humidity_tolerance = 40

var temperature_requirement = 40
var temperature_tolerance = 8

var underground_requirement = ["nest"]
var underground_tolerance = []


var music_requirement = ["classical"]
var music_tolerance = [""]

onready var egg_textures = {
	"chicken": preload("res://assets/eggs/chicken.png"),
	"chode": preload("res://assets/eggs/chode-egg.png"),
}


func set_chode_egg():
	GlobalData.egg_growth = 0.0
	growth_rate = 3.0
	type = "chode"
	sprite.texture = egg_textures.chode
	self.reset()
	humidity_requirement = 40
	humidity_tolerance = 50
	temperature_requirement = 50
	temperature_tolerance = 5
	underground_requirement = ["pillow"]
	underground_tolerance = []
	music_requirement = ["metal"]
	music_tolerance = ["jazz"]

func set_chicken_egg():
	GlobalData.egg_growth = 0.0
	growth_rate = 8.0
	type = "chicken"
	sprite.texture = egg_textures.chicken
	self.reset()
	humidity_requirement = 60
	humidity_tolerance = 40
	temperature_requirement = 40
	temperature_tolerance = 8
	underground_requirement = ["nest"]
	underground_tolerance = []
	music_requirement = ["classical"]
	music_tolerance = ["jazz"]


func _ready():
	set_chicken_egg()
	$Graphics.rotation_degrees = 0.0
	if !static_egg:
		pass
	else:
		set_process(false)

func _process(delta: float):
	$Graphics/Notification.rotation_degrees = -$Graphics.rotation_degrees


# possibilities are
#  "sad" "happy" "hot" "cold" "dry" "humid"

func can_grow():
	return get_egg_mood() in ["happy", "superhappy"]

func get_growth_happiness_rate():
	var egg_mood = get_egg_mood()
	if egg_mood == "superhappy":
		return 1.5
	elif egg_mood == "happy":
		return 1.0
	else:
		return 0.0

func get_egg_mood():
	var annoyances = []
	var tolerances = []
	var temperature = GlobalData.temperature
	if temperature < temperature_requirement - temperature_tolerance / 2:
		annoyances.append("cold")
	elif temperature > temperature_requirement + temperature_tolerance / 2:
		annoyances.append("hot")

	var humidity = GlobalData.humidity
	if humidity < humidity_requirement - humidity_tolerance / 2:
		annoyances.append("dry")
	elif humidity > humidity_requirement + humidity_tolerance / 2:
		annoyances.append("humid")

	var base = GlobalData.base
	if not base in underground_requirement:
		if not base in underground_tolerance:
			print("bad base ", base)
			annoyances.append("bad-base")
		else:
			tolerances.append("base")

	var music = GlobalData.music
	if not music in music_requirement:
		# allow wanting silence when having no actual use
		if music == null:
			if music_tolerance.size() != 0:
				annoyances.append("music")
		else:
			if not music in music_tolerance:
				print("bad music ", music)
				annoyances.append("bad-music")
			else:
				tolerances.append("music")

	if annoyances.size() > 0:
		return annoyances[randi() % annoyances.size()]
	else:
		if tolerances.size() > 0:
			return "happy"
		else:
			return "superhappy"

func _on_egg_click():
	pass

func wiggle():
	$AnimationPlayer.play("wiggle")
	$Graphics/Notification.activate(get_egg_mood())
