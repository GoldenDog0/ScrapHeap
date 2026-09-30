extends Sprite2D

var fading = false

func _on_tutorial_exit(body: Node2D) -> void:
	if body is Player:
		fading = true


func _process(_delta: float) -> void:
	if fading:
		$PointLight2D.energy *= 0.95
		if $PointLight2D.energy <= 0.01:
			$PointLight2D.hide()
			fading = false
