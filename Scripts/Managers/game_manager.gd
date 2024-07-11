extends SceneManager

@export var _character : CharacterBody3D
@onready var _pause_menu : Control = $"UI/Pause Menu"
@onready var _current_level : Node3D = $Dungeon
@onready var _player : Node = $Player
@onready var _event_manager : Node = $"Event Manager"
@onready var _camera : Camera3D = $Barbarian/SpringArm3D/Camera

func _ready():
	# So I can skip the title scene...
	if not File.progress:
		File.new_game()
	# Position the character at the start position
	_character.position = _current_level.get_player_start_position()
	await get_tree().process_frame
	# Fade in
	super._ready()

func start_event(event, disable_player : bool = true):
	if not event || not event.has_method("run_event"):
		push_warning("Event : " + event + " does not have a run_event method.")
		return
	if disable_player:
		_player.enabled = false
	event.run_event(_event_manager)

func end_event(use_fade : bool = false):
	if _event_manager.camera.current:
		if use_fade:
			await _fade.to_black()
		_camera.make_current()
		_event_manager.camera.reparent(_event_manager)
		if use_fade:
			await _fade.to_clear()
	_player.enabled = true

# Pause and unpause the game, display pause menu
func toggle_pause():
	get_tree().paused = !get_tree().paused
	if get_tree().paused:
		_pause_menu.open()
	else:
		_pause_menu.close()

# Return to the title scene
func _on_exit_pressed():
	change_scenes("res://Scenes/title.tscn")

# Open settings menu
func _on_settings_pressed():
	_settings_menu.open(_pause_menu)
