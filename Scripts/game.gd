extends Node2D

@onready var main = get_tree().get_root().get_node("Scene")
@onready var meteor = load("res://Scenes/meteor.tscn")
@onready var meteor_big = load("res://Scenes/meteor_big.tscn")

@onready var level_1: Node2D = $Level1
@onready var level_2: Node2D = $Level2
@onready var level_3: Node2D = $Level3

@onready var character: CharacterBody2D = $CharacterBody2D
@onready var end: CanvasLayer = $End
@onready var score_timer: Timer = $Score
@onready var final_score: Label = $End/ColorRect/PanelContainer/MarginContainer/VBoxContainer/Label2
@onready var music: AudioStreamPlayer2D = $AudioListener2D/AudioStreamPlayer2D
@onready var score_label: Label = $CharacterBody2D/Camera2D/ScoreLabel
@onready var level_label: Label = $CharacterBody2D/Camera2D/LevelLabel
@onready var meteorites: Timer = $Meteorites
@onready var end_sfx: AudioStreamPlayer2D = $AudioListener2D/AudioStreamPlayer2D5
@onready var button1: TouchScreenButton = $CharacterBody2D/Camera2D/TouchScreenButton
@onready var button2: TouchScreenButton = $CharacterBody2D/Camera2D/TouchScreenButton2
@onready var button3: TouchScreenButton = $CharacterBody2D/Camera2D/TouchScreenButton3
@onready var spawn_grace: Timer = $SpawnGrace

const BASE_SCORE_PER_SECOND = 10
const SCORE_PER_GEM = 100
const BUTTONS_OFFSET_SCALE = 1.5
const TOUCHSCREEN_CONTROLS_SCALE = 1.35
const STARTING_LEVEL = 1
const SCORE_TO_OPEN_PORTAL_1 = 750
const SCORE_TO_OPEN_PORTAL_2 = 2000

var score : int = 0
var gems : int = 0
var levelState : int = STARTING_LEVEL

func _ready() -> void:
	end.hide()
	on_meteorites_timeout()
	# Hide legacy TouchScreenButtons — replaced by virtual controls below
	button1.visible = false
	button2.visible = false
	button3.visible = false
	# Add ?touch=1 to the URL to force virtual controls on desktop for testing
	var force_touch := false
	if OS.get_name() == "Web":
		force_touch = JavaScriptBridge.eval("new URLSearchParams(window.location.search).get('touch') === '1'")
	if DisplayServer.is_touchscreen_available() or force_touch:
		_setup_virtual_controls()
	level_1.deactivate()
	level_2.deactivate()
	level_3.deactivate()
	load_level(STARTING_LEVEL)

func _setup_virtual_controls() -> void:
	var canvas := CanvasLayer.new()
	canvas.layer = 10
	add_child(canvas)

	# Joystick — bottom-left
	var joystick: Control = preload("res://Scripts/virtual_joystick.gd").new()
	joystick.anchor_left = 0.0
	joystick.anchor_top = 1.0
	joystick.anchor_right = 0.0
	joystick.anchor_bottom = 1.0
	joystick.offset_left = 60 * BUTTONS_OFFSET_SCALE
	joystick.offset_top = -140 * BUTTONS_OFFSET_SCALE
	joystick.offset_right = 140 * BUTTONS_OFFSET_SCALE
	joystick.offset_bottom = -80 * BUTTONS_OFFSET_SCALE
	joystick.scale = Vector2(TOUCHSCREEN_CONTROLS_SCALE, TOUCHSCREEN_CONTROLS_SCALE)
	canvas.add_child(joystick)

	# Jump button — bottom-right
	var jump_btn: Control = preload("res://Scripts/virtual_jump_button.gd").new()
	jump_btn.anchor_left = 1.0
	jump_btn.anchor_top = 1.0
	jump_btn.anchor_right = 1.0
	jump_btn.anchor_bottom = 1.0
	jump_btn.offset_left = -120 * BUTTONS_OFFSET_SCALE
	jump_btn.offset_top = -140 * BUTTONS_OFFSET_SCALE
	jump_btn.offset_right = -100 * BUTTONS_OFFSET_SCALE
	jump_btn.offset_bottom = -80 * BUTTONS_OFFSET_SCALE
	jump_btn.scale = Vector2(TOUCHSCREEN_CONTROLS_SCALE, TOUCHSCREEN_CONTROLS_SCALE)
	canvas.add_child(jump_btn)

func drop_meteor(repeat : int):
	for i in range(repeat):
		var instance = meteor.instantiate()
		var spread := int(200 + score / 10.0)
		var spawn_pos := character.global_position + Vector2(randi_range(-spread, spread), randi_range(-250, -280))
		instance.global_position = spawn_pos
		var aim := (character.global_position - spawn_pos).angle() * randf_range(0.9, 1.1)
		instance.dir = aim + PI / 2
		instance.global_rotation = aim - PI / 2
		main.add_child.call_deferred(instance)
		await get_tree().create_timer(0.1).timeout

func drop_meteor_big(repeat : int):
	for i in range(repeat):
		var instance = meteor_big.instantiate()
		var spread := int(200 + score / 10.0)
		var spawn_pos := character.global_position + Vector2(randi_range(-spread, spread), randi_range(-250, -280))
		instance.global_position = spawn_pos
		var aim := (character.global_position - spawn_pos).angle() * randf_range(0.9, 1.1)
		instance.dir = aim + PI / 2
		instance.global_rotation = aim - PI / 2
		main.add_child.call_deferred(instance)
		await get_tree().create_timer(0.1).timeout

func on_meteorites_timeout() -> void:
	@warning_ignore("integer_division")
	var inc = floori(score/600)
	if inc > 3:
		inc = 3
	if !spawn_grace.is_stopped():
		inc -= 2
	if inc < 0:
		inc = 0;
	drop_meteor(randi_range(1, 3 + inc))
	await get_tree().create_timer(0.1).timeout
	drop_meteor_big(randi_range(0, 2 + inc))

func on_score_timer_timeout() -> void:
	score_increase(BASE_SCORE_PER_SECOND * levelState)
	if score >= SCORE_TO_OPEN_PORTAL_1 and levelState == 1:
		level_1.show_portal()
	if score >= SCORE_TO_OPEN_PORTAL_2 and levelState == 2:
		#level_2.show_portal()
		pass

func score_increase(amount:int) -> void:
	score += amount
	score_label.text = "Score: " + str(score)

func next_level() -> void:
	change_to_level(levelState + 1)

func change_to_level(new:int) -> void:
	unload_level(levelState)
	#do effects
	#set position
	get_tree().call_group("meteors", "queue_free")
	load_level(new)
	levelState = new
	level_label.text = "Level: " + str(levelState)
	spawn_grace.start()

func unload_level(target:int) -> void:
	character.reset_buffs()
	match target:
		1:
			level_1.deactivate()
		2:
			level_2.deactivate()
		3:
			level_3.deactivate()

func load_level(target:int) -> void:
	match target:
		1:
			level_1.activate()
		2:
			level_2.activate()
		3:
			level_3.activate()

func on_game_over() -> void:
	set_physics_process(false)
	end_sfx.play(0.25)
	score_timer.stop()
	music.stop()
	meteorites.stop()
	spawn_grace.stop()
	await get_tree().create_timer(0.3).timeout
	end.show()
	final_score.text = str(score)

func on_button_pressed() -> void:
	get_tree().reload_current_scene()
