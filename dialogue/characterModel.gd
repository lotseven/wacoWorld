extends Node
class_name characterModel
var dStart

func _ready() -> void:
	dStart = $dialogueStarter
	dStart.get_node("prompt").visible = false

func _on_dialogue_starter_body_entered(body: Node2D) -> void:
	SignalBus.emit_signal('updateCharacterTalking', true, self.name) # Replace with function body.
	dStart.get_node("prompt").visible = true

func _on_dialogue_starter_body_exited(body: Node2D) -> void:
	SignalBus.emit_signal('updateCharacterTalking', false, self.name) # Replace with function body.
	dStart.get_node("prompt").visible = false
