class_name InteractionEvent extends Area3D

func interact():
	$/root/Game.start_event(self)

func set_interactable(is_interactable : bool):
	collision_layer = 16 if is_interactable else 0
