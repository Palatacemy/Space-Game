extends Area2D

func _on_area_entered(_area: Area2D) -> void:
	if _area.is_in_group("player"):
		queue_free()
