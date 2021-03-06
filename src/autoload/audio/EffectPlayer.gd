extends AudioStreamPlayer

onready var audio_stream_random_pitch = AudioStreamRandomPitch.new()

var currently_playing = null

signal audio_finished

func _ready():
	# TODO can be expanded to have another audio stream instead? Which is not random
	# Maybe make different groups and settings for effects in the Effects node
	stream = audio_stream_random_pitch
	connect("finished", self, "_on_finished")

func _on_finished():
	emit_signal("audio_finished", self)

func is_available():
	return currently_playing == null

func play_effect(track_path: String):
	# TODO might not be always desired...
	var effect_audio_stream = load(track_path)
	if effect_audio_stream is AudioStreamMP3:
		effect_audio_stream.loop = false
	elif effect_audio_stream is AudioStreamOGGVorbis:
		effect_audio_stream.loop = false
	elif effect_audio_stream is AudioStreamSample:
		pass
	stream.audio_stream = effect_audio_stream
	currently_playing = track_path
	play()

func finish():
	currently_playing = null
	# TODO maybe clear audio track?
