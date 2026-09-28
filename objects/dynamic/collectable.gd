extends Area2D

var image = load("res://objects/dynamic/sparkle.png")

func _ready() -> void:
	$Sprite2D.texture = image
	
func _process(_delta: float) -> void:
	$Sprite2D.rotation += 0.1
