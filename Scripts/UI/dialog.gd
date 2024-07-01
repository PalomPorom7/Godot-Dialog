extends Control

@onready var _speaker : Label = $VBoxContainer/Speaker
@onready var _dialogue : RichTextLabel = $VBoxContainer/Dialogue
@onready var _continue : Button = $Box/Continue
var _lines
var _current_line : int
var _speaker_name : String
var _typing_time : float

func open():
	visible = true

func close():
	visible = false

func display_line(line, speaker : String = ""):
	_lines = [line]
	_current_line = 0
	_speaker_name = speaker
	open()
	_continue.grab_focus()
	_next_line()

func display_multiline(lines, speaker : String = ""):
	_lines = lines
	_current_line = 0
	_speaker_name = speaker
	open()
	_continue.grab_focus()
	_next_line()

func _next_line():
	_speaker.visible = (_speaker_name != "")
	_speaker.text = _speaker_name
	_dialogue.text = _lines[_current_line]
	_dialogue.visible_characters = 0
	_typing_time = 0
	while _dialogue.visible_characters < _dialogue.get_total_character_count():
		_typing_time += get_process_delta_time()
		@warning_ignore("narrowing_conversion")
		_dialogue.visible_characters = File.settings.typing_speed * _typing_time
		await get_tree().process_frame

func _on_continue_pressed():
	if _dialogue.visible_characters < _dialogue.get_total_character_count():
		_dialogue.visible_characters = _dialogue.get_total_character_count()
	else:
		_current_line += 1
		if _current_line < _lines.size():
			_next_line()
		else:
			close()
