extends Node


var known = []

var humidity = 30
var temperature = 40
var base = "pillow"
var music = null

var egg_growth = 0.0

var new_egg = 0.0

# ui registration
var bestiary: Bestiary = null
var incubator: Incubator = null

func _ready():
	pass

func _process(delta):
	if incubator:
		temperature = incubator.get_temperature()
		base = incubator.get_base()
		humidity = incubator.get_humidity()
		music = incubator.radio.get_song()

	egg_growth += delta * incubator.egg.get_growth_happiness_rate() * incubator.egg.growth_rate

	if egg_growth >= 100.0:
		incubator.egg_finished()


func unlocked_creature(creature_name: String) -> bool:
	return false
