extends Area3D

@onready var _door : Node3D = get_parent()

func interact():
	$/root/Game.start_event(self)

func run_event(em):
	if _door.is_open():
		$/root/Game.end_event()
		collision_layer = 0
		await _door.close()
		collision_layer = 16
		return
	else:
		if File.progress.knows_password:
			await em.dialog.display_line("Ahem...\n[color=blue]Password1[/color]!")
			$/root/Game.end_event()
			collision_layer = 0
			await _door.open()
			collision_layer = 16
			return
		else:
			await em.dialog.display_line("The door is sealed shut.")
	$/root/Game.end_event()
