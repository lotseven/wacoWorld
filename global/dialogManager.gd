extends Node

func _ready() -> void:
	SignalBus.connect("updateCharacterTalking", Callable(self, "updateCharacterTalking"))
	
func updateCharacterTalking(b, char):
	if b: # if a character can be spoken to
		pass
	else:
		pass
