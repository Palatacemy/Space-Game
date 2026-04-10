extends Control

const JOYSTICK_SCALE = 1.5

const RADIUS := 50.0 * JOYSTICK_SCALE
const KNOB_RADIUS := 22.0 * JOYSTICK_SCALE
const DEAD_ZONE := 0.35 * JOYSTICK_SCALE

var _touch_index := -1
var _knob_offset := Vector2.ZERO

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP

func _draw() -> void:
	var center := size / 2.0
	draw_circle(center, RADIUS, Color(1, 1, 1, 0.15))
	draw_arc(center, RADIUS, 0.0, TAU, 64, Color(1, 1, 1, 0.5), 2.5)
	draw_circle(center + _knob_offset, KNOB_RADIUS, Color(1, 1, 1, 0.7))

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		_handle_press(event.index, event.position, event.pressed)
	elif event is InputEventScreenDrag and event.index == _touch_index:
		_move_knob(event.position)
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		_handle_press(0, event.position, event.pressed)
	elif event is InputEventMouseMotion and _touch_index == 0:
		_move_knob(event.position)

func _handle_press(index: int, screen_pos: Vector2, pressed: bool) -> void:
	if pressed and _touch_index == -1:
		if get_global_rect().grow(KNOB_RADIUS).has_point(screen_pos):
			_touch_index = index
	elif not pressed and index == _touch_index:
		_touch_index = -1
		_knob_offset = Vector2.ZERO
		_release_all()
		queue_redraw()

func _move_knob(screen_pos: Vector2) -> void:
	var local := screen_pos - global_position - size / 2.0
	if local.length() > RADIUS:
		local = local.normalized() * RADIUS
	_knob_offset = local
	_apply_axis()
	queue_redraw()

func _apply_axis() -> void:
	var x := _knob_offset.x / RADIUS
	if x < -DEAD_ZONE:
		Input.action_press("left")
		Input.action_release("right")
	elif x > DEAD_ZONE:
		Input.action_press("right")
		Input.action_release("left")
	else:
		_release_all()

func _release_all() -> void:
	Input.action_release("left")
	Input.action_release("right")
