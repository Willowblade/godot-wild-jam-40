extends Node2D


onready var fire_texture = preload("res://assets/eggs/notification/fire.png")
onready var ocean_texture = preload("res://assets/eggs/notification/ocean.png")
onready var desert_texture = preload("res://assets/eggs/notification/desert.png")
onready var ice_texture = preload("res://assets/eggs/notification/ice.png")
onready var happy_texture = preload("res://assets/eggs/notification/happy.png")
onready var sad_texture = preload("res://assets/eggs/notification/sad.png")

onready var mapping = {
	"sad": sad_texture,
	"happy": happy_texture,
	"hot": fire_texture,
	"cold": ice_texture,
	"dry": desert_texture,
	"humid": ocean_texture,
}

#func is_active():
#	return not $Timer.is_stopped()

func _ready():
	$Timer.connect("timeout", self, "_on_timer_timeout")
	hide()


func activate(type: String):
	$Overlay.texture = mapping[type]
	show()
	$Timer.start()

func _on_timer_timeout():
	hide()
