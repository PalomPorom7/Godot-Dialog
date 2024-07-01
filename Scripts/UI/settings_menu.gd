extends Menu

signal volume_changed(new_volume : float)

@onready var _camera_invert_x : CheckBox = $"VBoxContainer/GridContainer/Camera Invert X"
@onready var _camera_invert_y : CheckBox = $"VBoxContainer/GridContainer/Camera Invert Y"
@onready var _volume : HSlider = $"VBoxContainer/GridContainer/Volume"
@onready var _typing_speed : HSlider = $"VBoxContainer/GridContainer/Typing Speed"

func _ready():
	_camera_invert_x.button_pressed = File.settings.camera_invert_x
	_camera_invert_y.button_pressed = File.settings.camera_invert_y
	_volume.value = File.settings.volume
	_typing_speed.value = File.settings.typing_speed
	Music.set_linear_volume(File.settings.volume)
	volume_changed.emit(File.settings.volume)

func _on_camera_invert_x_toggled(toggled_on : bool):
	File.settings.camera_invert_x = toggled_on

func _on_camera_invert_y_toggled(toggled_on : bool):
	File.settings.camera_invert_y = toggled_on

func _on_volume_value_changed(value : float):
	File.settings.volume = value
	Music.set_linear_volume(value)
	volume_changed.emit(value)

func _on_typing_speed_value_changed(value : float):
	@warning_ignore("narrowing_conversion")
	File.settings.typing_speed = value

func close():
	File.save_settings()
	super.close()
