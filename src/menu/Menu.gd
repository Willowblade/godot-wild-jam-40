extends Control

onready var _tab_container := $CanvasLayer/TabContainer

func _ready():
	Flow.game_state = Flow.STATE.MENU
	AudioEngine.play_background_music("jazz", 0.0)
