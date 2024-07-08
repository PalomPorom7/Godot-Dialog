extends Area3D

func interact():
	$/root/Game.start_event(self)

func run_event(em):
	match await em.dialog.display_options(
		"I just got back from the haberdashery, and I think I might have splurged a little too much.  What do you think of my new robes?",
		[
			"You look fantastic!",
			"The hat is a little much...",
			"Maybe you didn't spend enough?"
		]
	):
		0:
			await em.dialog.display_line("Thanks!  I think so too!", "Mage")
		1:
			await em.dialog.display_line("Hmm... You're probably right, and it was the most expensive part.\nMaybe I can return it for a discount.", "Mage")
		2:
			await em.dialog.display_line("Purple isn't really my colour, but it was the cheapest.\n", "Mage")
	$/root/Game.end_event()
