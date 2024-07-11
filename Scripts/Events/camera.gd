extends Camera3D

var _tween : Tween

func move_to_marker(marker : Node3D):
	global_position = marker.global_position
	global_rotation = marker.global_rotation
	make_current()

func pan_direction(direction : Vector3, duration : float) -> Signal:
	make_current()
	return _tween_camera(global_position + direction, duration)

func pan_to_marker(marker : Node3D, duration : float, match_rotation : bool = true) -> Signal:
	make_current()
	return _tween_camera(marker.global_position, duration, marker.global_rotation, match_rotation)

func follow_path(path : PathFollow3D, duration : float) -> Signal:
	reparent(path)
	position = Vector3.ZERO
	rotation = Vector3.ZERO
	make_current()
	if _tween && _tween.is_running():
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(path, "progress_ratio", 1, duration)
	return _tween.finished

func _tween_camera(target_destination : Vector3, duration : float, target_rotation : Vector3 = Vector3.ZERO, match_rotation : bool = false) -> Signal:
	if _tween && _tween.is_running():
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(self, "global_position", target_destination, duration)
	if match_rotation:
		_tween.parallel().tween_property(self, "global_rotation", target_rotation, duration)
	return _tween.finished
