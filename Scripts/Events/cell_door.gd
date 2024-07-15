extends Area3D

@onready var _door : Node3D = get_parent()
@onready var _character_markers : Array[Node] = $"Character Markers".get_children()
@onready var _rogue : CharacterBody3D = $"../../NPCs/Rogue"

func interact():
	$/root/Game.start_event(self)

func run_event(em):
	await em.barbarian.animate("Interact")
	if _door.is_open():
		$/root/Game.end_event()
		collision_layer = 0
		await _door.close()
		collision_layer = 16
	else:
		collision_layer = 0
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
		collision_layer = 16
