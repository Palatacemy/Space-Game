extends CharacterBody2D

@export var SPEED = 50.0

var dir : float
var real_spd = -SPEED * randf_range(0.85, 1.15)

func _physics_process(_delta: float) -> void:
	velocity = Vector2(0, real_spd).rotated(dir)
	move_and_slide()

func _on_timer_timeout() -> void:
	queue_free()
