extends Camera2D

func _draw() -> void:
	position = get_local_mouse_position().limit_length(10.0)
