extends Area2D

@onready var particles: CPUParticles2D = $CPUParticles2D

func _on_area_entered(_area: Area2D) -> void:
	if _area.is_in_group("player"):
		set_deferred("monitorable", false)
		set_deferred("monitoring", false)
		set_deferred("particles.emitting", false)
		hide()
