extends Node
class_name characterModel
var dStart
var diaManager = preload("res://dialogue/dialogManager.tscn")
var diaManInst # will be stored here for erasure etc

func _ready() -> void:
	dStart = $dialogueStarter
	dStart.get_node("prompt").visible = false

func _on_dialogue_starter_body_entered(body: Node2D) -> void:
	var diaManInst = diaManager.instantiate()
	get_tree().root.add_child(diaManInst)
	SignalBus.emit_signal('updateCharacterTalking', true, self.name) 
	dStart.get_node("prompt").visible = true

func _on_dialogue_starter_body_exited(body: Node2D) -> void:
	var inst = get_tree().root.get_node("dialogManager")
	if inst: inst.queue_free()
	SignalBus.emit_signal('updateCharacterTalking', false, self.name) 
	dStart.get_node("prompt").visible = false
