extends Area3D

func interact():
	$/root/Game.start_event(self)

func run_event(em):
	await em.dialog.display_line("There appears to be a door here, but it is locked.")
	$/root/Game.end_event()

