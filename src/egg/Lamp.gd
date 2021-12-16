extends ClickableTexture
class_name Lamp

onready var cap = $Cap
onready var light = $Cap/Light2D

onready var on_button = $OnButton
onready var off_button = $OffButton

onready var textures = {
	"on": preload("res://assets/objects/lamp/lamp-cap-on.png"),
	"off": preload("res://assets/objects/lamp/lamp-cap-off.png"),
}

onready var beam_start = $Start
onready var beam_pivot = $Pivot
onready var beam_end = $Cap/End

onready var beam_start_to_pivot_sprite = $StartToPivot
onready var beam_pivot_to_end_sprite = $PivotToEnd

const CENTER_PIVOT = false

func _ready():
	pass

func _process(delta):
	if CENTER_PIVOT:
		beam_pivot.global_position.x = (beam_start.global_position.x + beam_end.global_position.x) / 2
	beam_start_to_pivot_sprite.global_position = (beam_start.global_position + beam_pivot.global_position) / 2
	beam_pivot_to_end_sprite.global_position = (beam_pivot.global_position + beam_end.global_position) / 2

	beam_start_to_pivot_sprite.scale = Vector2(1, beam_start.global_position.distance_to(beam_pivot.global_position) / 5)
	beam_pivot_to_end_sprite.scale = Vector2(1, beam_pivot.global_position.distance_to(beam_end.global_position) / 5)

	var angle = atan2((beam_end.global_position - beam_pivot.global_position).y, (beam_end.global_position - beam_pivot.global_position).x)
	beam_pivot_to_end_sprite.rotation = angle + PI / 2

func turn_off():
	off_button.hide()
	on_button.show()
	cap.texture = textures["off"]
	light.enabled = false

func turn_on():
	off_button.show()
	on_button.hide()
	cap.texture = textures["on"]
	light.enabled = true


func get_cap_position() -> Vector2:
	return cap.position

func set_cap_position(new_position: Vector2):
	cap.global_position = new_position


func set_cap_rotation(new_rotation: float):
	cap.rotation_degrees = new_rotation


