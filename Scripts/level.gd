extends Node3D

@onready var _player_start : Marker3D = $"Player Start"

func get_player_start_position() -> Vector3:
	return _player_start.global_position
