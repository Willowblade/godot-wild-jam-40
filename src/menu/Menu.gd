extends Control

onready var _tab_container := $CanvasLayer/TabContainer


func _ready():
	Flow.game_state = Flow.STATE.MENU
	AudioEngine.play_background_music("jazz", 0.0)

	wiggle_eggs()

func wiggle_eggs():
	for egg in [$Sprite/Egg, $Sprite/Egg2, $Sprite/Egg3]:
		wiggle_egg(egg)

func wiggle_egg(egg: Egg):
	while true:
		yield(get_tree().create_timer(5 + randf() * 3), "timeout")
		egg.wiggle_small()
		egg.notification.activate(["sad", "happy", "superhappy", "cold", "dry", "music"][randi() % 6])


