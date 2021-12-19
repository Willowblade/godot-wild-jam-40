extends ClickableTexture
class_name Egg

onready var sprite = $Graphics/Sprite
onready var notification = $Graphics/Notification
onready var animation_player = $AnimationPlayer

export var static_egg = false

export var growth_rate = 1.0
export(String, "chicken", "octosquid", "molebear", "moose", "mouse", "unicorn", "sapling", "willow") var type = "chicken"


export var wiggle_time = 10.0
export var wiggle_variation = 1.0


# TODO we can move the logic to the incubator actually
var humidity_requirement = 60
var humidity_tolerance = 40

var temperature_requirement = 40
var temperature_tolerance = 8
var temperature_down_close_to_hatching = true

var underground_requirement = ["nest"]
var underground_tolerance = []


var music_requirement = ["classical"]
var music_tolerance = [""]

var growing = false


func set_octosquid_egg():
	growth_rate = 3.0
	humidity_requirement = 90
	humidity_tolerance = 40
	temperature_requirement = 50
	temperature_tolerance = 5
	underground_requirement = ["pillow"]
	underground_tolerance = []
	music_requirement = ["metal"]
	music_tolerance = ["jazz"]
	temperature_down_close_to_hatching = true

func set_moose_egg():
	growth_rate = 3.0
	humidity_requirement = 20
	humidity_tolerance = 10
	temperature_requirement = 10
	temperature_tolerance = 0
	underground_requirement = ["nest"]
	underground_tolerance = []
	music_requirement = []
	music_tolerance = []
	temperature_down_close_to_hatching = false

func set_willow_egg():
	growth_rate = 1.8
	humidity_requirement = 50
	humidity_tolerance = 20
	temperature_requirement = 35
	temperature_tolerance = 8
	underground_requirement = ["pillow"]
	underground_tolerance = []
	music_requirement = ["jazz"]
	music_tolerance = []
	temperature_down_close_to_hatching = true

func set_mouse_egg():
	growth_rate = 3.2
	humidity_requirement = 20
	humidity_tolerance = 40
	temperature_requirement = 40
	temperature_tolerance = 10
	underground_requirement = ["nest"]
	underground_tolerance = []
	music_requirement = ["classical"]
	music_tolerance = ["metal"]
	temperature_down_close_to_hatching = true

func set_unicorn_egg():
	growth_rate = 1.0
	humidity_requirement = 100
	humidity_tolerance = 20
	temperature_requirement = 45
	temperature_tolerance = 3
	underground_requirement = ["pillow"]
	underground_tolerance = []
	music_requirement = ["metal"]
	music_tolerance = []
	temperature_down_close_to_hatching = true
#
func set_chicken_egg():
	growth_rate = 4.0
	humidity_requirement = 60
	humidity_tolerance = 40
	temperature_requirement = 40
	temperature_tolerance = 8
	underground_requirement = ["nest"]
	underground_tolerance = []
	music_requirement = ["classical"]
	music_tolerance = ["jazz"]
	temperature_down_close_to_hatching = true

func set_molebear_egg():
	growth_rate = 2.5
	humidity_requirement = 40
	humidity_tolerance = 20
	temperature_requirement = 30
	temperature_tolerance = 8
	underground_requirement = ["nest"]
	underground_tolerance = []
	music_requirement = ["jazz"]
	music_tolerance = ["classical"]
	temperature_down_close_to_hatching = true

func set_sapling_egg():
	growth_rate = 1.0
	humidity_requirement = 60
	humidity_tolerance = 30
	temperature_requirement = 20
	temperature_tolerance = 5
	underground_requirement = ["nest"]
	underground_tolerance = []
	music_requirement = []
	music_tolerance = ["classical"]
	temperature_down_close_to_hatching = true

func set_growing():
	if !growing:
		growing = true

func stop_growing():
	if growing:
		if animation_player.is_playing() and animation_player.current_animation == "pulse":
			animation_player.stop()

func set_type(new_type):
	GlobalData.egg_growth = 0.0
	type = new_type
	sprite.texture = Database.BESTIARY[type].egg
	self.reset()
	if type == "chicken":
		set_chicken_egg()
	elif type == "octosquid":
		set_octosquid_egg()
	elif type == "mouse":
		set_mouse_egg()
	elif type == "moose":
		set_moose_egg()
	elif type == "sapling":
		set_sapling_egg()
	elif type == "molebear":
		set_molebear_egg()
	elif type == "unicorn":
		set_unicorn_egg()
	elif type == "willow":
		set_willow_egg()

func _ready():
	set_type(type)
	$Graphics.rotation_degrees = 0.0
	if !static_egg:
		pass
	else:
		set_process(false)

func _process(delta: float):
	$Graphics/Notification.rotation_degrees = -$Graphics.rotation_degrees


	if growing:
		if not animation_player.is_playing():
			animation_player.play("pulse", -1, 0.5)


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

	# shortcut when egg has fallen
	if GlobalData.egg_state == GlobalData.egg_states.FALLEN:
		return "sad"

	# set this temperature to off temperature for the end
	if GlobalData.egg_growth > 90 and temperature_down_close_to_hatching:
		temperature_requirement = 10.0
		temperature_tolerance = 1.0

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
			annoyances.append("bad-base")
		else:
			tolerances.append("base")

	var music = GlobalData.music
	if not music in music_requirement:
		# allow wanting silence when having no actual use
		if music == null:
			if music_requirement.size() != 0:
				annoyances.append("music")
		else:
			if not music in music_tolerance:
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

func get_annoyances():
	var annoyances = []

	var temperature = GlobalData.temperature

	# set this temperature to off temperature for the end
	if GlobalData.egg_growth > 90 and temperature_down_close_to_hatching:
		temperature_requirement = 10.0
		temperature_tolerance = 1.0

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
			annoyances.append("bad-base")

	var music = GlobalData.music
	if not music in music_requirement:
		# allow wanting silence when having no actual use
		if music == null:
			if music_requirement.size() != 0:
				annoyances.append("music")
		else:
			if not music in music_tolerance:
				annoyances.append("bad-music")

	return annoyances

func _on_egg_click():
	pass

func wiggle():
	animation_player.play("wiggle")
	notification.activate(get_egg_mood())

func wiggle_small():
	animation_player.play("wiggle_small")
	notification.activate("sad")
