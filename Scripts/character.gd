extends CharacterBody3D

@export_category("Locomotion")
@export var _walking_speed : float = 2
@export var _running_speed : float = 4
@export var _acceleration : float = 4
@export var _deceleration : float = 8
@export var _rotation_speed : float = PI * 2
@onready var _movement_speed : float = _walking_speed
var _direction : Vector3
var _angle_difference : float
var _xz_velocity : Vector3
var _can_move : bool = true:
	set(new_value):
		_can_move = new_value
		if not _can_move:
			_direction = Vector3.ZERO

@export_category("Jumping")
@export var _min_jump_height : float = 1.5
@export var _max_jump_height : float = 2.5
@export var _air_control : float = 0.5
@export var _air_brakes : float = 0.5
@export var _mass : float = 1
@onready var _jump_hold : Timer = $"Jump Hold"
var _min_jump_velocity : float
var _max_jump_velocity : float
var _gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var _animation : AnimationTree = $AnimationTree
@onready var _state_machine : AnimationNodeStateMachinePlayback = _animation["parameters/playback"]
@onready var _rig : Node3D = $Rig

@onready var _interact_range : RayCast3D = get_node_or_null("Rig/RayCast3D")

signal destination_reached

func _ready():
	_min_jump_velocity = sqrt(_min_jump_height * _gravity * _mass * 2)
	_max_jump_velocity = sqrt(_max_jump_height * _gravity * _mass * 2)

func animate(animation_name : String, locked : bool = true):
	if _state_machine.get_current_node() != "Locomotion":
		return
	if locked:
		_can_move = false
	_state_machine.travel("Misc/" + animation_name)
	while await _animation.animation_finished != animation_name:
		continue
	if locked:
		_can_move = true

func face_direction(forward_direction : float):
	_rig.rotation.y = forward_direction

func move(direction : Vector3):
	if not _can_move:
		return
	_direction = direction

func move_to_marker(marker : Marker3D, allowable_distance : float = 0.25, running : bool = false) -> Signal:
	var path : Vector3 = marker.global_position - global_position
	var stopping_distance : float
	if running:
		run()
	while path.length() > allowable_distance:
		path = marker.global_position - global_position
		stopping_distance = _xz_velocity.length() / 2 / _deceleration
		_direction = path.normalized() if path.length() > stopping_distance else Vector3.ZERO
		await get_tree().physics_frame
	_direction = Vector3.ZERO
	if running:
		walk()
	destination_reached.emit()
	return destination_reached

func follow_path(path, allowable_distance : float = 0.25, running : bool = false) -> Signal:
	var next_point : int = 0
	while next_point < path.size():
		await move_to_marker(path[next_point], allowable_distance, running)
		next_point += 1
	destination_reached.emit()
	return destination_reached

func snap_to_marker(marker : Node3D, match_y_rotation : bool = true):
	global_position = marker.global_position
	if match_y_rotation:
		_rig.global_rotation = marker.global_rotation

func walk():
	_movement_speed = _walking_speed

func run():
	_movement_speed = _running_speed

func start_jump():
	if not _can_move:
		return
	if is_on_floor():
		_state_machine.travel("Jump_Start")
		_jump_hold.start()
		_jump_hold.paused = false

func complete_jump():
	_jump_hold.paused = true

func interact():
	if _interact_range && _interact_range.is_colliding() && _interact_range.get_collider().has_method("interact"):
		_interact_range.get_collider().interact()

func _apply_jump_velocity():
	_jump_hold.paused = true
	if is_on_floor():
		velocity.y = _min_jump_velocity + (_max_jump_velocity - _min_jump_velocity) * min(1 - _jump_hold.time_left, 0.3) / 0.3

func _physics_process(delta : float):
	# If the player is giving movement input, face that direction
	if _direction:
		_angle_difference = wrapf(atan2(_direction.x, _direction.z) - _rig.rotation.y, -PI, PI)
		_rig.rotation.y += clamp(_rotation_speed * delta, 0, abs(_angle_difference)) * sign(_angle_difference)
	# Copy the character's x and z velocity to isolate from y.
	_xz_velocity = Vector3(velocity.x, 0, velocity.z)

	if is_on_floor():
		_ground_physics(delta)
	else:
		_air_physics(delta)

	# Apply adjusted xz velocity to the character
	velocity.x = _xz_velocity.x
	velocity.z = _xz_velocity.z

	move_and_slide()

func _ground_physics(delta : float):
	# Apply movement input to the xz velocity
	if _direction:
		# Accelerate
		if _direction.dot(velocity) >= 0:
			_xz_velocity = _xz_velocity.move_toward(_direction * _movement_speed, _acceleration * delta)
		# Turn around
		else:
			_xz_velocity = _xz_velocity.move_toward(_direction * _movement_speed, _deceleration * delta)
	# Decelerate
	else:
		_xz_velocity = _xz_velocity.move_toward(Vector3.ZERO, _deceleration * delta)
	
	_animation.set("parameters/Locomotion/blend_position", _xz_velocity.length() / _running_speed)

func _air_physics(delta : float):
	# Add the gravity.
	velocity.y -= _gravity * _mass * delta
	# Apply movement input to the xz velocity
	if _direction:
		# Accelerate
		if _direction.dot(velocity) >= 0:
			_xz_velocity = _xz_velocity.move_toward(_direction * _movement_speed, _acceleration * _air_control * delta)
		# Turn around
		else:
			_xz_velocity = _xz_velocity.move_toward(_direction * _movement_speed, _deceleration * _air_control * delta)
	# Decelerate
	else:
		_xz_velocity = _xz_velocity.move_toward(Vector3.ZERO, _deceleration * _air_brakes * delta)
