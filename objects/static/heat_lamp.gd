extends Sprite2D

var fading = false
var ticker = 0
var blink = 0

func _on_tutorial_exit(_body: Node2D) -> void:
	if self.has_meta("tutorial"):
		if _body is Player:
			fading = true

func _on_flicker_trigger(_body: Node2D) -> void:
	if _body is Player:
		fading = true

func _process(delta: float) -> void:
	if fading:
		ticker += 1 * delta
		$PointLight2D.energy = 0.8 + sin(ticker)/10 - blink
		blink = 0
		if randi_range(0,25) == 1:
			blink=1
		if ticker >= 1.25:
			$PointLight2D.energy = 0
			fading = false
