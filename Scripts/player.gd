extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var coyote_timer: Timer = $Timer
@onready var sfx1: AudioStreamPlayer2D = $"../AudioListener2D/AudioStreamPlayer2D2"
@onready var sfx2: AudioStreamPlayer2D = $"../AudioListener2D/AudioStreamPlayer2D3"
@onready var sfx3: AudioStreamPlayer2D = $"../AudioListener2D/AudioStreamPlayer2D4"
@onready var buff_timer: Timer = $BuffTimer
@onready var buff_timer_2: Timer = $BuffTimer2
@onready var end_particles: CPUParticles2D = $CPUParticles2D
@onready var jetpack_particles: CPUParticles2D = $CPUParticles2D2

@onready var mat1 = preload("res://Shaders/pl1.gdshader")

const JUMP_BUFFER_TIMER = .12
const SPEED = 120.0
const JUMP_VELOCITY = -220.0
const JETPACK_STRENGTH = -40
const MAX_JETPACK_CLIMB = -160

var jump_available : bool = true
var jump_buffer : bool = false
var coyote_time_activated : bool = false
var acc_rate = 0.0
var jump_pressed : bool = false

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		if !coyote_time_activated:
			coyote_timer.start()
			coyote_time_activated = true
		velocity += get_gravity() * delta
	else:
		if coyote_time_activated:
			coyote_time_activated = false
			coyote_timer.stop()
		jump_available = true
		if jump_buffer:
			Jump()
			jump_buffer = false
	
	if Input.is_action_just_pressed("jump"):
		jump_pressed = true
		if jump_available and (is_on_floor() or !coyote_timer.is_stopped()) and buff_timer_2.is_stopped():
			Jump()
		else:
			jump_buffer = true
			get_tree().create_timer(JUMP_BUFFER_TIMER).timeout.connect(on_jump_buffer_timeout)
	
	if Input.is_action_just_released("jump"):
		jump_pressed = false
	
	if jump_pressed and !buff_timer_2.is_stopped():
		if velocity.y > MAX_JETPACK_CLIMB:
			velocity.y += JETPACK_STRENGTH
		jetpack_particles.emitting = true
	else:
		jetpack_particles.emitting = false
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if direction:
		if !is_on_floor():
			acc_rate = direction * SPEED * 0.15
			velocity.x = move_toward(velocity.x, direction * SPEED, abs(acc_rate))
		else:
			velocity.x = direction * SPEED
	else:
		if !is_on_floor():
			acc_rate = SPEED * 0.08
		else:
			acc_rate = SPEED * 0.3
		velocity.x = move_toward(velocity.x, 0, acc_rate)

	move_and_slide()

	if direction == 1.0:
		sprite.flip_h = false
	elif direction == -1.0:
		sprite.flip_h = true

func Jump()->void:
	velocity.y = JUMP_VELOCITY
	jump_available = false
	coyote_timer.stop()
	coyote_time_activated = true

func on_jump_buffer_timeout()->void:
	jump_buffer = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("gem"):
		get_parent().score_increase(get_parent().SCORE_PER_GEM)
		get_parent().gems += 1
		sfx1.play()
	if area.is_in_group("buff"):
		buff_timer.start()
		sprite.use_parent_material = false
		sfx3.play()
	if area.is_in_group("buff2"):
		buff_timer_2.start()
		sfx2.play()
	if area.is_in_group("meteors") and buff_timer.is_stopped():
		game_over()

func _on_killbox_area_entered(_area: Area2D) -> void:
	if _area.is_in_group("player"):
		if buff_timer.is_stopped():
			game_over()
		else:
			velocity.y = JUMP_VELOCITY * 2
			jump_available = false

func on_buff_timer_timeout() -> void:
	sprite.use_parent_material = true

func game_over() -> void:
	end_particles.emitting = true
	set_physics_process(false)
	get_parent().on_game_over()
