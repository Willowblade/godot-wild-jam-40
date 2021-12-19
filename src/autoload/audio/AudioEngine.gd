"""
Audio Engine

"""
extends Node

onready var background_players = {
	"first": $BackgroundPlayer,
	"second": $SecondBackgroundPlayer,
}

var current_background_player: AudioStreamPlayer = null


const tracks = {
	"classical": "res://assets/audio/music/canon-in-d-major-by-kevin-macleod-from-filmmusic-io.mp3",
	"metal": "res://assets/audio/music/burn-the-world-waltz-by-kevin-macleod-from-filmmusic-io.mp3",
	"jazz": "res://assets/audio/music/shades-of-spring-by-kevin-macleod-from-filmmusic-io.mp3",
}

const sfx = {

}


onready var background_player: AudioStreamPlayer = $BackgroundPlayer
onready var effects: Node = $Effects


func convert_scale_to_db(scale: float):
	return 20 * log(scale) / log(10)


var background_audio = null

export var MAX_SIMULTANEOUS_EFFECTS = 10


func _ready():
	#play_background_music("light_rain")
	for _i in range(MAX_SIMULTANEOUS_EFFECTS):
		effects.add_effect()


func play_effect(effect_name: String):
	effects.play_effect(sfx[effect_name])

func play_background_music(track_name: String, timing = 0.0):
	var track_path = tracks[track_name]
	if background_audio == track_path:
		return

	var stream = load(track_path)
	var length = stream.get_length()
	print("Stream length ", length)
	var timestamp = fmod(timing, length)

	background_audio = track_path

	if current_background_player == null:
		current_background_player = background_players.first
		_play_background(stream, timestamp)
	else:
		if current_background_player == background_players.first:
			$AnimationPlayer.play("switch_2", -1, 10.0)
			current_background_player = background_players.second
			_play_background(stream, timestamp)

		elif current_background_player == background_players.second:
			$AnimationPlayer.play("switch_1", -1, 10.0)
			current_background_player = background_players.first
			_play_background(stream, timestamp)

func _play_background(stream, position):
	print("Playing background song!")
	current_background_player.stream = stream
	current_background_player.play(position)

func reset():
#	effects.reset()
	stop_background_music()


func stop_background_music():
	"""Stops the background music track"""
	if current_background_player.playing:
		current_background_player.stop()
		background_audio = null
