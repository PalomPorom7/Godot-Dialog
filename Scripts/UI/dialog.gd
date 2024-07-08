extends Control

@onready var _speaker : Label = $VBoxContainer/Speaker
@onready var _dialogue : RichTextLabel = $VBoxContainer/Dialogue
@onready var _continue : Button = $Box/Continue
@onready var _options : Array[Node] = $Options.get_children()
var _lines
var _current_line : int
var _speaker_name : String
var _typing_time : float

signal finished
signal finished_typing
signal selected(choice : int)

func open():
	visible = true

func close():
	visible = false

func display_line(line, speaker : String = "") -> Signal:
	_lines = [line]
	_current_line = 0
	_speaker_name = speaker
	open()
	_next_line()
	return finished

func display_multiline(lines, speaker : String = "") -> Signal:
	_lines = lines
	_current_line = 0
	_speaker_name = speaker
	open()
	_next_line()
	return finished

func display_options(line, choices) -> int:
	_lines = [line]
	_current_line = 0
	_speaker_name = ""
	open()
	_next_line()
	await finished_typing
	_continue.visible = false
	for i in _options.size():
		if i < choices.size():
			_options[i].text = choices[i]
			_options[i].visible = true
		else:
			_options[i].visible = false
	_options[0].grab_focus()
	return await selected

func _next_line():
	_speaker.visible = (_speaker_name != "")
	_speaker.text = _speaker_name
	_dialogue.text = _lines[_current_line]
	_dialogue.visible_characters = 0
	_continue.visible = true
	_continue.grab_focus()
	for i in _options.size():
		_options[i].visible = false
	_typing_time = 0
	while _dialogue.visible_characters < _dialogue.get_total_character_count():
		_typing_time += get_process_delta_time()
		@warning_ignore("narrowing_conversion")
		_dialogue.visible_characters = File.settings.typing_speed * _typing_time
		await get_tree().process_frame
	finished_typing.emit()

func _on_option_pressed(index : int):
	close()
	selected.emit(index)

func _on_continue_pressed():
	if _dialogue.visible_characters < _dialogue.get_total_character_count():
		_dialogue.visible_characters = _dialogue.get_total_character_count()
	else:
		_current_line += 1
		if _current_line < _lines.size():
			_next_line()
		else:
			close()
			finished.emit()
