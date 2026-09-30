extends Area2D
var notified = false

func _ready() -> void:
	self.modulate.a = 0.0
	
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if not(notified):
			notified = true
			fade_in()
			await get_tree().create_timer(4.0).timeout
			fade_out()

func fade_in():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 1.0)
	await tween.finished

func fade_out():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	await tween.finished
