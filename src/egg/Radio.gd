extends Node2D

onready var next_button = $NextButton
onready var previous_button = $PreviousButton
onready var power_button = $PowerButton


var enabled = false
var songs = ["classical", "jazz", "metal"]
var current_index = 0

var timer = 0.0

func _ready():
	pass

func _process(delta):
	timer += delta

func toggle_power():
	if enabled:
		deactivate()
	else:
		activate()

func get_song():
	return songs[current_index]

func deactivate():
	enabled = false
	AudioEngine.stop_background_music()
	GlobalData.music = null

func play():
	print("Current index ", current_index)
	GlobalData.music = songs[current_index]
	AudioEngine.play_background_music(songs[current_index], timer)

func activate():
	enabled = true
	play()

func next_song():
	if not enabled:
		return
	current_index = (current_index + 1) % songs.size()
	play()

func previous_song():
	if not enabled:
		return
	current_index = (current_index - 1) % songs.size()
	if current_index < 0:
		current_index += songs.size()
	play()

