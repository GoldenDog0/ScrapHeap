extends Area2D

@export_range(0.0,10.0,0.1) var minLight = 0.0
@export_range(0.0,10.0,0.1) var maxLight = 1.0
var timer = 0

func _process(delta: float) -> void:
	timer += delta
	$PointLight2D.energy = abs(sin(timer*1.5)) * maxLight + minLight

func _on_body_entered(_body) -> void:
	timer = 0
