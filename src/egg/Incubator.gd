extends Node2D
class_name Incubator

var dragging: Node2D = null


onready var radio = $Radio
onready var egg: Egg = $EggContainer/Egg
onready var lamp = $Lamp
onready var egg_area =  $EggContainer/Egg/Area2D
onready var placeholder_egg = $EggContainer/EggPlaceholder

onready var moisturizer = $MoisturizerContainer/Moisturizer
onready var moisturizer_placeholder = $MoisturizerContainer/MoisturizerPlaceholder
onready var moisturizer_area =  $MoisturizerContainer/Moisturizer/MoisturizerArea

onready var hatching_animation = $HatchingAnimation

onready var nest = $Nest

onready var pillow_replacement = $Bases/PillowContainer.nest
onready var nest_replacement = $Bases/NestContainer.nest


var egg_pickup_location: Vector2 = Vector2()
var egg_pickup_rotation: float = 0.0
onready var egg_start_location = $EggContainer.position
onready var lamp_start_location = lamp.position

var humidity = 0.0
const HUMIDITY_DECREASE_RATE = 2

const LAMP_MIN = 40
const LAMP_MAX = 100
const MAX_TEMPERATURE = 50.0
const MIN_TEMPERATURE = 20.0
const OFF_TEMPERATURE = 10.0

const WIGGLE_TIME = 6.0
const WIGGLE_VARIATION = 2.0

var waiting_for_hatch_animation = true


func _ready():
	$WiggleTimer.connect("timeout", self, "_on_wiggle_timer_timeout")
	$WiggleTimer.wait_time = WIGGLE_TIME + (0.5 - randf()) * WIGGLE_VARIATION
	$WiggleTimer.start()

	$HatchingAnimation.connect("done", self, "_on_hatching_animation_done")

	GlobalData.incubator = self
	GlobalData.egg_state = GlobalData.egg_states.IDLE
	egg.global_position = egg_start_location
	egg.rotation_degrees = 0.0
	placeholder_egg.global_position = egg_start_location

	egg.set_type("chicken")

	update_bases()

	GlobalData.bestiary.activate()
	GlobalData.bestiary.set_page(4)

func update_bases():
	for base in $Bases.get_children():
		if nest.nest_type == base.base_type.to_lower():
			base.hide()
		else:
			base.show()

func update_base(new_type: String):
	var lower_type = new_type.to_lower()

	if lower_type == "nest":
		AudioEngine.play_effect("chair-sound")
		$Nest.set_basic_nest()
	elif lower_type == "pillow":
		AudioEngine.play_effect("chair-sound")
		$Nest.set_luxury_cushion()

	update_bases()

func egg_fall():
	egg.notification.activate("annoyed")
	$AnimationPlayer.play("egg-fall")
	yield($AnimationPlayer, "animation_finished")
	GlobalData.egg_state = GlobalData.egg_states.FALLEN


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

func table_roll_sound():
	AudioEngine.play_effect("table-roll")

func _input(event):
	if GlobalData.bestiary.visible or GlobalData.egg_picker.visible or GlobalData.win_screen.visible:
		return

	if Input.is_action_just_pressed("debug_grow"):
		GlobalData.egg_growth += 10.0
	if Input.is_action_just_pressed("debug_increase_rate"):
		GlobalData.debug_rate = 10.0

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
							humidity += 10.0
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
					if egg_is_fallen() and !dragging:
						dragging = egg
						placeholder_egg.show()
						egg_pickup_location = egg.global_position
						egg_pickup_rotation = egg.rotation_degrees
				elif $Book.mouse_overlaps():
					GlobalData.bestiary.activate()

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
				if dragging:
					drop_dragging()

		if event.button_index == BUTTON_RIGHT:
			# drop the moisturizer
			drop_holding()

	if Input.is_action_just_pressed("ui_bestiary"):
		if GlobalData.bestiary.visible:
			GlobalData.bestiary.deactivate()
		else:
			GlobalData.bestiary.activate()

func egg_is_idle():
	return GlobalData.egg_state == GlobalData.egg_states.IDLE

func egg_is_fallen():
	return GlobalData.egg_state == GlobalData.egg_states.FALLEN

func _on_wiggle_timer_timeout():
	if GlobalData.egg_picker.visible or hatching_animation.visible or !egg.visible:
		$WiggleTimer.wait_time = WIGGLE_TIME + (0.5 - randf()) * WIGGLE_VARIATION
		$WiggleTimer.start()
		return

	if egg_is_fallen():
		egg.wiggle_small()
		$WiggleTimer.wait_time = WIGGLE_TIME + (0.5 - randf()) * WIGGLE_VARIATION
		$WiggleTimer.start()
		return

	if egg.get_annoyances().size() >= 2:
		# 40% chance to fall out
		if randf() < 0.3:
			egg_fall()
			$WiggleTimer.wait_time = WIGGLE_TIME + (0.5 - randf()) * WIGGLE_VARIATION
			$WiggleTimer.start()
			return

	if egg_is_idle():
		egg.wiggle()

	$WiggleTimer.wait_time = WIGGLE_TIME + (0.5 - randf()) * WIGGLE_VARIATION
	$WiggleTimer.start()


func drop_holding():
	if dragging is Moisturizer:
		dragging = null
		moisturizer.position = Vector2()
		moisturizer_placeholder.hide()


func start_new_egg(new_egg_type: String):
	# unlock the old egg
	GlobalData.unlock_creature(egg.type)
	egg.set_type(new_egg_type)
	egg.show()

func drop_dragging():
	if dragging is Lamp:
		dragging = null

	if dragging is Egg:
		dragging = null
		placeholder_egg.hide()
		if egg_area in $EggContainer/EggDropoff.get_overlapping_areas():
			egg.global_position = egg_start_location
			egg.rotation_degrees = 0.0
			GlobalData.egg_state = GlobalData.egg_states.IDLE
		else:
			egg.global_position = egg_pickup_location
			egg.rotation_degrees = egg_pickup_rotation

	if dragging in [pillow_replacement, nest_replacement]:
		dragging.position = Vector2()
		dragging.z_index = 2

		if dragging.get_node("Area2D") in $BaseDropoff.get_overlapping_areas():
			update_base(dragging.get_parent().base_type)

		dragging = null


func egg_finished():
	egg.hide()
	GlobalData.unlock_creature(egg.type)
	hatching_animation.set_creature(egg.type)
	hatching_animation.play()

func after_showing_win():
	GlobalData.activate_egg_picker()

func _on_hatching_animation_done():
	hatching_animation.check_for_enter = false
	hatching_animation.hide()
	hatching_animation.set_process_input(false)
	if GlobalData.should_show_win():
		GlobalData.win_achieved = true
		GlobalData.win_screen.activate()
	else:
		GlobalData.activate_egg_picker()
