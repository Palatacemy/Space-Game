extends Control

const BUTTON_SCALE = 1.5

const RADIUS := 40.0 * BUTTON_SCALE

var _touch_index := -1
var _pressed := false

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP

func _draw() -> void:
	var center := size / 2.0
	var alpha := 0.7 if _pressed else 0.45
	draw_circle(center, RADIUS, Color(1, 1, 1, 0.15))
	draw_arc(center, RADIUS, 0.0, TAU, 64, Color(1, 1, 1, alpha), 2.5)
	draw_string(
		ThemeDB.fallback_font,
		Vector2(center.x - RADIUS, center.y + 6),
		"JUMP",
		HORIZONTAL_ALIGNMENT_CENTER, RADIUS * 2, 14,
		Color(1, 1, 1, alpha)
	)

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		_handle_press(event.index, event.position, event.pressed)
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		_handle_press(0, event.position, event.pressed)

func _handle_press(index: int, screen_pos: Vector2, pressed: bool) -> void:
	if pressed and _touch_index == -1:
		if get_global_rect().grow(10).has_point(screen_pos):
			_touch_index = index
			_pressed = true
			Input.action_press("jump")
			queue_redraw()
	elif not pressed and index == _touch_index:
		_touch_index = -1
		_pressed = false
		Input.action_release("jump")
		queue_redraw()
