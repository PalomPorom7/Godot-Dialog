extends Area3D

func run_event(_em):
	await _em.dialog.display_line("You have entered the Mage's room!")
	# who is saying what
	# how are they acting?
	# what is the camera looking at...
	# etc...
	
	$/root/Game.end_event()

func _on_body_entered(_body : Node3D):
	$/root/Game.start_event(self)
