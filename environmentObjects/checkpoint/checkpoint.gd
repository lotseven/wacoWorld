extends Area2D
@onready var player = get_tree().get_first_node_in_group("player")


func _on_body_entered(body: Node2D) -> void:
	SignalBus.emit_signal('updateCheckpoint', self)
