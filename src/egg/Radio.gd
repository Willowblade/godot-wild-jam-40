extends Node2D

onready var next_button = $NextButton
onready var previous_button = $PreviousButton
onready var power_button = $PowerButton


onready var states = [
	$S1, $S2, $S3
]

var enabled = false
var songs = ["classical", "jazz", "metal"]
var current_index = 0

var timer = 0.0

func _ready():
	deactivate()

func _process(delta):
	timer += delta

func toggle_power():
	press_button($PowerButton)
	if enabled:
		deactivate()
	else:
		activate()

func get_song():
	if enabled:
		return songs[current_index]
	else:
		return null

func deactivate():
	AudioEngine.play_effect("radio-on")
	enabled = false
	AudioEngine.stop_background_music()
	GlobalData.music = null
	update_lights()

func update_lights():
	if enabled:
		$OnOff.show()
	else:
		$OnOff.hide()

	for i in range(states.size()):
		if enabled:
			if i == current_index:
				states[i].show()
			else:
				states[i].hide()
		else:
			states[i].hide()

func press_button(button: ClickableTexture):
	button.z_index = 2
	yield(get_tree().create_timer(0.4), "timeout")
	button.z_index = -1

func play():
	print("Current index ", current_index)
	GlobalData.music = songs[current_index]
	AudioEngine.play_background_music(songs[current_index], timer)

func activate():
	AudioEngine.play_effect("radio-on")
	enabled = true
	play()
	update_lights()

func next_song():
	AudioEngine.play_effect("radio-next")
	press_button($NextButton)
	if not enabled:
		return
	current_index = (current_index + 1) % songs.size()
	play()
	update_lights()

func previous_song():
	AudioEngine.play_effect("radio-next")
	press_button($PreviousButton)
	if not enabled:
		return
	current_index = (current_index - 1) % songs.size()
	if current_index < 0:
		current_index += songs.size()
	play()
	update_lights()

