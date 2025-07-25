extends Node
class_name character
var dStart

func _ready() -> void:
	dStart = $dialogueStarter

func _on_dialogue_starter_body_entered(body: Node2D) -> void:
	SignalBus.emit_signal('updateCharacterTalking', true, self.get_parent().name) # Replace with function body.

func _on_dialogue_starter_body_exited(body: Node2D) -> void:
	SignalBus.emit_signal('updateCharacterTalking', false, self.get_parent().name) # Replace with function body.
