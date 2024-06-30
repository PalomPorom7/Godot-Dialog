extends Control

@onready var _speaker : Label = $VBoxContainer/Speaker
@onready var _dialogue : RichTextLabel = $VBoxContainer/Dialogue
@onready var _continue : Button = $Box/Continue

func display_line(line : String, speaker : String = ""):
	_speaker.visible = (speaker != "")
	_speaker.text = speaker
	_dialogue.text = line
	open()
	_continue.grab_focus()

func open():
	visible = true

func close():
	visible = false

func _on_continue_pressed():
	close()
