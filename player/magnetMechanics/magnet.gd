extends Node2D
var angle
var pos
var grouped = false
var glow
func _ready():
	rotation_degrees = angle
	position = pos
	glow = $glow
	glow.visible = false

func buttonPressed() -> void:
	if !grouped: # if the magnet is being joined into the group, make the thing visible
		glow.visible = true
	else: 
		glow.visible = false
	SignalBus.emit_signal("magnetButtonClick", self)
	
