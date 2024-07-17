class_name ScriptedEvent extends Node

signal finished

func run_event(_em : EventManager) -> Signal:
	finished.emit()
	return finished

func end_event():
	$/root/Game.end_event()
