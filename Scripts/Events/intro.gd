extends ScriptedEvent

@onready var _secondary_event : ScriptedEvent = $"Secondary Event"

func run_event(em : EventManager) -> Signal:
	await em.fade.to_clear()
	await em.dialog.display_line("Hello, world!")
	File.progress.intro_played = true
	await _secondary_event.run_event(em)
	$/root/Game.end_event()
	return super.run_event(em)
