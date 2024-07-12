extends Area3D

@onready var _camera_markers : Array[Node] = $"Camera Markers".get_children()
#@onready var _path_follow : PathFollow3D = $Path3D/PathFollow3D
@onready var _mage : CharacterBody3D = get_parent()

func interact():
	$/root/Game.start_event(self)

func run_event(em):
	await em.fade_to_marker(_camera_markers[0])
	await em.dialog.display_line("Who are you?  What are you doing here?", "Mage")
	_mage.animate("Cheer")
	await em.dialog.display_line("[shake]GET OUT OF MY STUDY![/shake]", "Mage")
	$/root/Game.end_event(true)
