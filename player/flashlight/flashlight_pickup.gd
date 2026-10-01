extends Area2D

var blink = 0
var ticker = 0

func _on_body_entered(body: Node2D) -> void:
	self.hide()	

func _process(delta: float) -> void:

	ticker += 0.02 * delta
	$Light.energy = 0.8 + sin(ticker)/10 - blink
	blink = 0
	if randi_range(0,25) == 1:
		blink=1
