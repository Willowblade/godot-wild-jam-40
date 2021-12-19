extends Node

enum STATE {MENU, GAME}


onready var game_scenes := {
	STATE.MENU: preload("res://src/menu/Menu.tscn"),
	STATE.GAME: preload("res://src/egg/IncubatorTestScene.tscn"),
}


var game_state = STATE.MENU

var menu_tab = null

var pause_menu = null

func _ready():
	pass


func go_to_game():
	game_state = STATE.GAME
	AudioEngine.stop_background_music()
	get_tree().change_scene_to(game_scenes[STATE.GAME])

func go_to_menu():
	GlobalData.reset()
	game_state = STATE.MENU
	get_tree().paused = not get_tree().paused
	get_tree().change_scene_to(game_scenes[STATE.MENU])

func deferred_quit() -> void:
	get_tree().quit()

func toggle_paused():

	if pause_menu:
		get_tree().paused = not get_tree().paused
		if get_tree().paused:
			pause_menu.show()
		else:
			pause_menu.hide()

func _unhandled_input(event : InputEvent):
	if InputMap.has_action("toggle_full_screen") and event.is_action_pressed("toggle_full_screen"):
		OS.window_fullscreen = not OS.window_fullscreen

	if game_state == STATE.GAME:
		if InputMap.has_action("ui_cancel") and event.is_action_pressed("ui_cancel"):
			if GlobalData.incubator and GlobalData.incubator.dragging:
				GlobalData.incubator.drop_holding()
			elif GlobalData.bestiary and GlobalData.bestiary.visible:
				GlobalData.bestiary.deactivate()
			else:
				toggle_paused()

