class_name Progress extends Resource

@export var times_spoken_with_npc : Array[int]
@export var knows_password : bool
@export var intro_played : bool = false

func _init():
	times_spoken_with_npc = [0, 0, 0]
