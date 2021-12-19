extends Node


var known = []
#var known = ["chicken", "octosquid"]

var humidity = 30
var temperature = 40
var base = "pillow"
var music = null

var debug_rate = 1.0


# ui registration
var bestiary: Bestiary = null
var egg_picker: EggPicking = null
var incubator: Incubator = null

# egg state
enum egg_states {IDLE, FALLEN}
var egg_growth = 0.0
var new_egg = 0.0
var egg_state = egg_states.IDLE


func unlock_creature(creature_name):
	if not creature_name in known:
		known.push_back(creature_name)

func reset():
	bestiary = null
	egg_picker = null
	incubator = null

func _ready():
	pass

func _process(delta):
	if incubator:
		temperature = incubator.get_temperature()
		base = incubator.get_base()
		humidity = incubator.get_humidity()
		music = incubator.radio.get_song()

		if incubator.egg and incubator.egg.visible:
			if incubator.egg.can_grow():
				egg_growth += delta * incubator.egg.get_growth_happiness_rate() * incubator.egg.growth_rate * debug_rate
				incubator.egg.set_growing()
			else:
				incubator.egg.stop_growing()

			if egg_growth >= 100.0:
				incubator.egg_finished()


func unlocked_creature(creature_name: String) -> bool:
	return creature_name in known


func selected_new_egg(new_egg_name):
	print("Picked egg ", new_egg_name)
	if incubator:
		egg_picker.hide()
		incubator.start_new_egg(new_egg_name)

func activate_egg_picker():
	# fill in list of egg_picker with eggs old and new that the player can choose
	egg_picker.shuffle_eggs()
	egg_picker.set_graphics()
	egg_picker.activate()

