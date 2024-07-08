extends Node3D

@export var _is_open : bool
var _closed_y_position : float
var _tween : Tween

func _ready():
	_closed_y_position = position.y + 4 if _is_open else position.y

func is_open() -> bool:
	return _is_open

func open() -> Signal:
	_is_open = true
	return _move(_closed_y_position - 4)

func close() -> Signal:
	_is_open = false
	return _move(_closed_y_position)

func _move(new_y_position : float) -> Signal:
	if _tween && _tween.is_running():
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property($wall_half, "position:y", new_y_position, 1)
	return _tween.finished
