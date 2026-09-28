extends Area2D

signal playerEnterBoxRange()
signal playerLeftBoxRange()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		playerEnterBoxRange.emit()
		print("on signal sent")


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		playerLeftBoxRange.emit()
		print("off signal sent")
