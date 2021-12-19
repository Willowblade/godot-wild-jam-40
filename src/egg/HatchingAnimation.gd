extends Node2D


export var ROTATION_SPEED = 180

onready var sprites = {
	"chicken": {
		"top": preload("res://assets/eggs/chicken-top.png"),
		"bottom": preload("res://assets/eggs/chicken-bottom.png"),
		"creature": preload("res://assets/creature/chick.png"),
		"name": "Chick",
		"flavor": "Predictable!"
	},
	"octosquid": {
		"top": preload("res://assets/eggs/squid-top.png"),
		"bottom": preload("res://assets/eggs/squid-bottom.png"),
		"creature": preload("res://assets/creature/octosquid.png"),
		"name": "Octosquid",
		"flavor": "Woah! Rad!"
	},
	"mouse": {
		"top": preload("res://assets/eggs/mouse-top.png"),
		"bottom": preload("res://assets/eggs/mouse-bottom.png"),
		"creature": preload("res://assets/creature/mouse.png"),
		"name": "Mouse",
		"flavor": "Stay here!!"
	},
	"moose": {
		"top": preload("res://assets/eggs/moose-top.png"),
		"bottom": preload("res://assets/eggs/moose-bottom.png"),
		"creature": preload("res://assets/creature/moose.png"),
		"name": "Moose",
		"flavor": "Should I wrestle it?"
	},
	"molebear": {
		"top": preload("res://assets/eggs/molebear-top.png"),
		"bottom": preload("res://assets/eggs/molebear-bottom.png"),
		"creature": preload("res://assets/creature/molebear.png"),
		"name": "Molebear",
		"flavor": "Mole? Bear?"
	},
	"sapling": {
		"top": preload("res://assets/eggs/sapling-top.png"),
		"bottom": preload("res://assets/eggs/sapling-bottom.png"),
		"creature": preload("res://assets/creature/sapling.png"),
		"name": "Sapling",
		"flavor": "I should write a thesis on this!!"
	},
	"unicorn": {
		"top": preload("res://assets/eggs/unicorn-top.png"),
		"bottom": preload("res://assets/eggs/unicorn-bottom.png"),
		"creature": preload("res://assets/creature/unicorn.png"),
		"name": "Unicorn",
		"flavor": "Granny never told me this!"
	},
	"willow": {
		"top": preload("res://assets/eggs/willow-top.png"),
		"bottom": preload("res://assets/eggs/willow-bottom.png"),
		"creature": preload("res://assets/creature/willow.png"),
		"name": "Lil' Willow",
		"flavor": "Wi(tt)ll ow(d) developer!"
	}
}

var check_for_enter = false

func play_sound():
	AudioEngine.play_effect("egg-hatch")

signal done

func _ready():
	$AnimationPlayer.connect("animation_finished", self, "_on_animation_finished")

func _on_animation_finished(animation_name: String):
	print("Animation finished")
	check_for_enter = true
	set_process_input(true)

func set_creature(creature: String):
	$EggContainer/TopHalf.texture = sprites[creature].top
	$EggContainer/BottomHalf.texture = sprites[creature].bottom
	$Creature.texture = sprites[creature].creature
	$Flavor.text = sprites[creature].flavor
	$Message.text = "You hatched " + sprites[creature].name + "!"

func _process(delta):
	$Background.rotation_degrees += delta * ROTATION_SPEED
	if check_for_enter:
		if Input.is_action_just_pressed("ui_accept"):
			print("UI ACCEPT!")
			emit_signal("done")

func _input(event):
	if check_for_enter:
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT:
				if event.pressed:
					emit_signal("done")


func play():
	show()
	$AnimationPlayer.play("hatch")
