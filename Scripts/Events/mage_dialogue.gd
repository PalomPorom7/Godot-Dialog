extends Area3D

func interact():
	$/root/Game.start_event(self)

func run_event(em):
	match await em.dialog.display_options(
		"What do you want?",
		[
			"I'm here to see the prisoner.",
			"Nothing."
		],
	):
		0:
			await em.dialog.display_line("Alright, the guard told me to expect you.\nThe password to open the door is [color=blue]Password1[/color].", "Mage")
			File.progress.knows_password = true
		1:
			await em.dialog.display_line("Quit wasting my time!  Can't you see I'm busy?", "Mage")
	$/root/Game.end_event()
