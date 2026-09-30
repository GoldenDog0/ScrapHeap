extends Area2D

signal buttonPress(tutorial: bool)
signal buttonDepress(tutorial: bool)

var objects = 0
var depressimg = load("res://objects/static/buttonUp.png")
var pressimg = load("res://objects/static/buttonDown.png")
var presssfx = load("res://sfx/buttonDown.mp3")
var depresssfx = load("res://sfx/buttonUp.mp3")

func _ready() -> void:
	$Sprite2D.texture=depressimg

func _button_down(_body) -> void:
	objects += 1
#	print(objects)
	if objects == 1:
		$Sprite2D.texture=pressimg
		buttonPress.emit(self.get_meta("tutorial"))
		$ButtonPress.play()	
	
func _button_up(_body) -> void:
	objects -= 1
#	print(objects)
	if objects == 0:
		$Sprite2D.texture=depressimg
		buttonDepress.emit(self.get_meta("tutorial"))
		$ButtonDepress.play()
		
