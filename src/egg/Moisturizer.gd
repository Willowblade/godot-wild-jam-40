extends ClickableTexture
class_name Moisturizer

onready var spray_scene = preload("res://src/egg/Spray.tscn")
onready var sprays = $Sprays

func _ready():
	pass

func spray():
	var spray = spray_scene.instance()
	sprays.add_child(spray)
	spray.emitting = true

	$Moisturizer.hide()
	$MoisturizerPressed.show()
	$Timer.start()
	yield(get_tree().create_timer(2.0), "timeout")
	sprays.remove_child(spray)
	spray.queue_free()


func _on_timer_timeout():
	$Moisturizer.show()
	$MoisturizerPressed.hide()
