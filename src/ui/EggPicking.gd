extends Control
class_name EggPicking


var eggs = ["chicken", "octosquid", "chicken"]

var ready = false

onready var egg_buttons = [
	$Eggs/FirstEgg, $Eggs/SecondEgg, $Eggs/ThirdEgg,
]

func _ready():
	GlobalData.egg_picker = self
	$Eggs/FirstEgg.connect("pressed", self, "_on_first_egg_pressed")
	$Eggs/SecondEgg.connect("pressed", self, "_on_second_egg_pressed")
	$Eggs/ThirdEgg.connect("pressed", self, "_on_third_egg_pressed")

func shuffle_eggs():
	eggs = []
	var unknown_eggs = []
	for possibility in Database.BESTIARY.keys():
		if GlobalData.unlocked_creature(possibility):
			pass
		else:
			unknown_eggs.push_back(possibility)
	unknown_eggs.shuffle()

	var known_eggs = GlobalData.known.duplicate()
	known_eggs.shuffle()
	for i in range(2):
		if known_eggs.size() <= i:
			continue
		else:
			eggs.push_back(known_eggs[i])

	var i = 0
	if unknown_eggs.size() > 0:
		while eggs.size() < 3:
			eggs.push_back(unknown_eggs[i])
			i += 1
	eggs.shuffle()

func set_graphics():
	var i = 0
	for egg in eggs:
		egg_buttons[i].texture_normal = Database.BESTIARY[egg].egg
		i += 1

func activate():
	show()
	ready = false
	yield(get_tree().create_timer(0.5), "timeout")
	ready = true

func _on_first_egg_pressed():
	if ready:
		GlobalData.selected_new_egg(eggs[0])

func _on_second_egg_pressed():
	if ready:
		GlobalData.selected_new_egg(eggs[1])

func _on_third_egg_pressed():
	if ready:
		GlobalData.selected_new_egg(eggs[2])
