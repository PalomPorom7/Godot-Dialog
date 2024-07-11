extends Node

@onready var barbarian : CharacterBody3D = $"../Barbarian"
@onready var dialog : Control = $"../UI/Dialog"
@onready var fade : ColorRect = $"../UI/Fade"
@onready var camera : Camera3D = $Camera3D
@onready var _player_camera : Camera3D = $"../Barbarian/SpringArm3D/Camera"

func position_cinematic_camera_to_match_player_camera():
	camera.move_to_marker(_player_camera)

func fade_to_marker(marker : Node3D) -> Signal:
	await fade.to_black()
	camera.move_to_marker(marker)
	return fade.to_clear()
