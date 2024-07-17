extends InteractionEvent

#@onready var _camera_markers : Array[Node] = $"Camera Markers".get_children()
#@onready var _path_follow : PathFollow3D = $Path3D/PathFollow3D
@onready var _mage : CharacterBody3D = get_parent()
@onready var _character_markers : Array[Node] = $"Character Markers".get_children()

func run_event(em : EventManager):
	await em.fade.to_black()
	em.barbarian.snap_to_marker(_character_markers[2])
	await em.fade.to_clear()
	await em.dialog.display_line("You'll need a key, hold on a second.", "Mage")
	await _mage.move_to_marker(_character_markers[1])
	await _mage.animate("Interact")
	await _mage.move_to_marker(_character_markers[0])
	_mage.animate("Interact")
	await em.dialog.display_line("Here it is.  Good luck!", "Mage")

	$/root/Game.end_event(true)
