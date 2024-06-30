extends SceneManager

@export var _character : CharacterBody3D
@onready var _pause_menu : Control = $"UI/Pause Menu"
@onready var _current_level : Node3D = $Dungeon

func _ready():
	# So I can skip the title scene...
	if not File.progress:
		File.new_game()
	# Position the character at the start position
	_character.position = _current_level.get_player_start_position()
	await get_tree().process_frame
	# Fade in
	super._ready()

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
