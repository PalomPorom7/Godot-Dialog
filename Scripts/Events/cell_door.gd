extends InteractionEvent

@onready var _door : Node3D = get_parent()
@onready var _character_markers : Array[Node] = $"Character Markers".get_children()
@onready var _rogue : CharacterBody3D = $"../../NPCs/Rogue"

func run_event(em : EventManager):
	await em.barbarian.animate("Interact")
	if _door.is_open():
		$/root/Game.end_event()
		set_interactable(false)
		await _door.close()
		set_interactable(true)
	else:
		set_interactable(false)
		_door.open()
		await em.barbarian.move_to_marker(_character_markers[0])
		await em.dialog.display_line("Thanks!", "Rogue")
		$/root/Game.end_event()
		await _rogue.follow_path(
			[
				_character_markers[1],
				_character_markers[2],
				_character_markers[3],
			],
			0.5,
			true
		)
		set_interactable(true)
