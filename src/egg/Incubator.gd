extends Node2D
class_name Incubator

var dragging: Node2D = null
var egg_state = 'idle'

onready var radio = $Radio
onready var egg = $EggContainer/Egg
onready var lamp = $Lamp
onready var egg_area =  $EggContainer/Egg/Area2D
onready var placeholder_egg = $EggContainer/EggPlaceholder

onready var moisturizer = $MoisturizerContainer/Moisturizer
onready var moisturizer_placeholder = $MoisturizerContainer/MoisturizerPlaceholder
onready var moisturizer_area =  $MoisturizerContainer/Moisturizer/MoisturizerArea

onready var nest = $Nest

onready var pillow_replacement = $Bases/PillowContainer.nest
onready var nest_replacement = $Bases/NestContainer.nest

enum egg_states {IDLE, FALLEN}

var egg_pickup_location: Vector2 = Vector2()
var egg_pickup_rotation: float = 0.0
onready var egg_start_location = $EggContainer.position
onready var lamp_start_location = lamp.position

var humidity = 0.0
const HUMIDITY_DECREASE_RATE = 2

const LAMP_MIN = 40
const LAMP_MAX = 100
const MAX_TEMPERATURE = 50.0
const MIN_TEMPERATURE = 30.0
const OFF_TEMPERATURE = 10.0

const WIGGLE_TIME = 8.0
const WIGGLE_VARIATION = 2.0


func _ready():
	$WiggleTimer.connect("timeout", self, "_on_wiggle_timer_timeout")
	$WiggleTimer.wait_time = WIGGLE_TIME + (0.5 - randf()) * WIGGLE_VARIATION
	$WiggleTimer.start()

	GlobalData.incubator = self
	egg_state = egg_states.IDLE
	egg.global_position = egg_start_location
	egg.rotation_degrees = 0.0
	placeholder_egg.global_position = egg_start_location
	update_bases()

func update_bases():
	for base in $Bases.get_children():
		if nest.nest_type == base.base_type.to_lower():
			base.hide()
		else:
			base.show()

func update_base(new_type: String):
	var lower_type = new_type.to_lower()

	if lower_type == "nest":
		$Nest.set_basic_nest()
	elif lower_type == "pillow":
		$Nest.set_luxury_cushion()

	update_bases()

func egg_fall():
	$AnimationPlayer.play("egg-fall")
	yield($AnimationPlayer, "animation_finished")
	egg_state = egg_states.FALLEN

func get_temperature() -> float:
	if lamp.off_button.visible:
		var distance = lamp.cap.global_position.distance_to(egg_start_location)
		# TODO can be more complex but need to determine bounds
		var temperature = MAX_TEMPERATURE - (distance - LAMP_MIN) / (LAMP_MAX - LAMP_MIN) * (MAX_TEMPERATURE - MIN_TEMPERATURE)
		return temperature
	else:
		return OFF_TEMPERATURE

func get_base() -> String:
	return nest.nest_type

func get_humidity() -> float:
	return humidity

func _process(delta):
	humidity -= HUMIDITY_DECREASE_RATE * delta
	if humidity < 0.0:
		humidity =  min(max(0.0, humidity), 100.0)

	if Input.is_action_just_pressed("ui_accept"):
		egg_fall()

	if dragging:
		if dragging is Lamp:
			var mouse_position = get_local_mouse_position()
			var distance = mouse_position.distance_to(egg_start_location)
			if distance > LAMP_MIN and distance < LAMP_MAX and mouse_position.y < egg_start_location.y - 20:
				lamp.set_cap_position(mouse_position)
				var lamp_rotation = egg_start_location.angle_to_point(mouse_position)
				lamp.set_cap_rotation(rad2deg(lamp_rotation) - 90)
			else:
				distance = max(min(distance, LAMP_MAX), LAMP_MIN)
				if mouse_position.y < egg_start_location.y - 20:
					var actual_position = egg_start_location + (mouse_position - egg_start_location).normalized() * distance
					lamp.set_cap_position(actual_position)
					var lamp_rotation = egg_start_location.angle_to_point(mouse_position)
					lamp.set_cap_rotation(rad2deg(lamp_rotation) - 90)

		if dragging is Egg:
			egg.rotation_degrees = 0.0
			egg.global_position = get_local_mouse_position() + Vector2(0, 5)

		if dragging is Moisturizer:
			moisturizer.rotation_degrees = 0.0
			moisturizer.global_position = get_local_mouse_position() + Vector2(0, 5)

		if dragging == nest_replacement:
			nest_replacement.global_position = get_local_mouse_position() + Vector2(0, 5)
		elif dragging == pillow_replacement:
			pillow_replacement.global_position = get_local_mouse_position() + Vector2(0, 5)

#	var lamp_rotation = egg.global_position.angle_to_point(lamp.cap.global_position)
#	lamp.set_cap_rotation(rad2deg(lamp_rotation) - 90)

	GlobalData.temperature = get_temperature()

func _input(event):
	if event is InputEventMouseMotion:
		if egg.mouse_overlaps():
			pass

	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				if moisturizer.mouse_overlaps():
					if dragging is Moisturizer:
						if moisturizer_area in $MoisturizerContainer/MoisturizerDropoff.get_overlapping_areas():
							dragging = null
							moisturizer.position = Vector2()
							moisturizer_placeholder.hide()
						else:
							moisturizer.spray()
							humidity += 12.5
							humidity =  min(max(0.0, humidity), 100.0)
					else:
						if !dragging:
							dragging = moisturizer
							moisturizer_placeholder.show()
				elif lamp.mouse_overlaps():
					if !dragging:
						dragging = lamp
				elif lamp.on_button.mouse_overlaps():
					lamp.turn_on()
					GlobalData.temperature = get_temperature()
				elif lamp.off_button.mouse_overlaps():
					lamp.turn_off()
					GlobalData.temperature = get_temperature()
				elif radio.power_button.mouse_overlaps():
					radio.toggle_power()
				elif radio.next_button.mouse_overlaps():
					radio.next_song()
				elif radio.previous_button.mouse_overlaps():
					radio.previous_song()
				elif pillow_replacement.mouse_overlaps():
					if !dragging:
						dragging = pillow_replacement
						dragging.z_index = 10
				elif nest_replacement.mouse_overlaps():
					if !dragging:
						dragging = nest_replacement
						dragging.z_index = 10

				elif egg.mouse_overlaps():
					if egg_state == egg_states.FALLEN and !dragging:
						dragging = egg
						placeholder_egg.show()
						egg_pickup_location = egg.global_position
						egg_pickup_rotation = egg.rotation_degrees

				elif moisturizer.mouse_overlaps():
					if dragging is Moisturizer:
						if moisturizer_area in $MoisturizerContainer/MoisturizerDropoff.get_overlapping_areas():
							dragging = null
							moisturizer.position = Vector2()
							moisturizer_placeholder.hide()
						else:
							moisturizer.spray()
					else:
						if !dragging:
							dragging = moisturizer
							moisturizer_placeholder.show()
			else:
				if dragging is Lamp:
					dragging = null

				if dragging is Egg:
					dragging = null
					placeholder_egg.hide()
					if egg_area in $EggContainer/EggDropoff.get_overlapping_areas():
						egg.global_position = egg_start_location
						egg.rotation_degrees = 0.0
						egg_state = egg_states.IDLE
					else:
						egg.global_position = egg_pickup_location
						egg.rotation_degrees = egg_pickup_rotation

				if dragging in [pillow_replacement, nest_replacement]:
					dragging.position = Vector2()
					dragging.z_index = 2

					if dragging.get_node("Area2D") in $BaseDropoff.get_overlapping_areas():
						update_base(dragging.get_parent().base_type)

					dragging = null

		if event.button_index == BUTTON_RIGHT:
			# drop the moisturizer
			if dragging is Moisturizer:
					dragging = null
					moisturizer.position = Vector2()
					moisturizer_placeholder.hide()


func _on_wiggle_timer_timeout():
	if egg_state == egg_states.IDLE:
		egg.wiggle()

	$WiggleTimer.wait_time = WIGGLE_TIME + (0.5 - randf()) * WIGGLE_VARIATION
	$WiggleTimer.start()


func egg_finished():
	if egg.type == "chicken":
		egg.set_chode_egg()
	elif egg.type == "chode":
		egg.set_chicken_egg()
