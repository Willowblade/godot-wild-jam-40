extends Control
class_name WinScreen


func _ready():
	GlobalData.win_screen = self
	$Button.connect("pressed", self, "after_win")

func activate():
	show()

func deactivate():
	hide()

func after_win():
	deactivate()
	GlobalData.incubator.after_showing_win()
