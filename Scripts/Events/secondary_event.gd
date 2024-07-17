extends ScriptedEvent

func run_event(em : EventManager) -> Signal:
	await em.dialog.display_line("Secondary Event!")
	return super.run_event(em)
