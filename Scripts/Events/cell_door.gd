extends Area3D

func interact():
	$/root/Game.start_event(self)

func run_event(_em):
	$/root/Game.end_event()
