extends Control
class_name EggPicking


var eggs = ["chicken", "octosquid", "chicken"]

var ready = false

func _ready():
	GlobalData.egg_picker = self
	$Eggs/FirstEgg.connect("pressed", self, "_on_first_egg_pressed")
	$Eggs/SecondEgg.connect("pressed", self, "_on_second_egg_pressed")
	$Eggs/ThirdEgg.connect("pressed", self, "_on_third_egg_pressed")

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
