extends Node2D
class_name ClickableTexture

export var clickable_texture_path: NodePath
onready var clickable_node = get_node(clickable_texture_path)
var texture = null
var texture_data = null


func _ready():
	print(clickable_texture_path)
	texture = clickable_node.texture
	texture_data = texture.get_data()
	texture_data.lock()

func reset():
	texture = clickable_node.texture
	texture_data = texture.get_data()
	texture_data.lock()

func mouse_overlaps():
	return _is_mouse_inside_texture()

# TODO maybe move to texture
func _is_mouse_inside_texture() -> bool:
	var texture_position : Vector2 = clickable_node.get_local_mouse_position() + texture.get_size() / 2
	if texture_position.x > 0 and texture_position.x < texture.get_size().x and texture_position.y > 0 and texture_position.y < texture.get_size().y:
		var alpha_value : float = texture_data.get_pixelv(texture_position).a
		return alpha_value > 0
	return false
