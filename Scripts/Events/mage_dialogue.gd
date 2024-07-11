extends Area3D

#@onready var _camera_markers : Array[Node] = $"Camera Markers".get_children()
@onready var _path_follow : PathFollow3D = $Path3D/PathFollow3D

func interact():
	$/root/Game.start_event(self)

func run_event(em):
	await em.fade_to_marker(_path_follow)
	await em.dialog.display_line("Have you heard about the dangerous criminal the guard locked up?", "Mage")
	em.camera.follow_path(_path_follow, 10)
	await em.dialog.display_line("You can see him through the window in the guard's chamber.", "Mage")
	await em.dialog.display_line("Rumour has it they're a real psychopath.", "Mage")
	em.camera.pan_direction(Vector3.UP, 1)
	$/root/Game.end_event(true)
