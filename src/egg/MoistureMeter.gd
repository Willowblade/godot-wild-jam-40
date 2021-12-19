extends Node2D

onready var meter = $Meter
onready var pointer = $Pointer

func _ready():
	pass

func _process(delta):
	set_moisture_pointer()

func set_moisture_pointer():
	var humidity = GlobalData.humidity
	pointer.rotation_degrees = 15 + humidity / 100 * 150
