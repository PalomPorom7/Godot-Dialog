extends Area3D

func interact():
	$/root/Game.start_event(self)

func run_event(em):
	await em.dialog.display_multiline(
		[
			"Hello, I'm a mage!",
			"Don't bother looking at that conspicuous wall over there."
		],
		"Mage"
	)
	await em.dialog.display_line("That's not suspicious at all.", "Barbarian")
	$/root/Game.end_event()

