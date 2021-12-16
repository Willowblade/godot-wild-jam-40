extends ClickableTexture
class_name Egg

export var static_egg = false

export var growth_rate = 1.0
export var type = "chicken"


export var wiggle_time = 10.0
export var wiggle_variation = 1.0

var happiness = 0.0
var growth = 0.0


# TODO we can move the logic to the incubator actually
var humidity_requirement = 60
var humidity_tolerance = 5

var temperature_requirement = 40
var temperature_tolerance = 8

var underground_requirement = ["nest"]
var underground_tolerance = []



func _ready():
	$Graphics.rotation_degrees = 0.0
	if !static_egg:
		$WiggleTimer.connect("timeout", self, "_on_wiggle_timer_timeout")
		$WiggleTimer.wait_time = wiggle_time + (0.5 - randf()) * wiggle_variation
		$WiggleTimer.start()
	else:
		set_process(false)



func _process(delta: float):
	growth += growth_rate * delta

	$Graphics/Notification.rotation_degrees = -$Graphics.rotation_degrees


# possibilities are
#  "sad" "happy" "hot" "cold" "dry" "humid"

func get_egg_mood():
	var temperature = GlobalData.temperature
	if temperature < temperature_requirement - temperature_tolerance / 2:
		return "cold"
	elif temperature > temperature_requirement + temperature_tolerance / 2:
		return "hot"
	else:
		return "happy"

func _on_wiggle_timer_timeout():
	$AnimationPlayer.play("wiggle")
	$Graphics/Notification.activate(get_egg_mood())
	$WiggleTimer.wait_time = wiggle_time + (0.5 - randf()) * wiggle_variation
	$WiggleTimer.start()

func mouse_overlaps():
	return _is_mouse_inside_texture()

func _on_egg_click():
	pass
