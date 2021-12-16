extends HBoxContainer
class_name ToCItem


func _ready():
	pass

func set_name(text: String):
	$Name.text = text

func set_number(number: int):
	$PageNumber.text = str(number)


func _on_name_pressed():
	SignalHub.on_clicked_bestiary_link(int($PageNumber.text))
