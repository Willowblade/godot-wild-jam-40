extends Control


func _ready():
	GlobalData.win_screen = self
	$Button.connect("pressed", self, "deactivate")

func activate():
	show()

func deactivate()
	hide()
