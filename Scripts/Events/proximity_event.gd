class_name ProximityEvent extends Area3D

func _ready():
	body_entered.connect(_on_body_entered)
	collision_mask = 256

func _on_body_entered(_body : Node3D):
	$/root/Game.start_event(self)
