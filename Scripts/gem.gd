extends Area2D

func _on_area_entered(_area: Area2D) -> void:
	if _area.is_in_group("player"):
		set_deferred("monitorable", false)
		set_deferred("monitoring", false)
		hide()
