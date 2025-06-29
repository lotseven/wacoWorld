extends Node2D
var angle
var pos
var grouped = false
var glow
var player 

func _ready():
	player = get_tree().get_first_node_in_group("player")
	rotation_degrees = angle
	position = pos
	glow = $glow
	glow.visible = false

func buttonPressed() -> void:
	#if player.clickMode == 'activate':
	if !grouped: # if the magnet is being joined into the group, make the thing visible
		glow.visible = true
	else: 
		glow.visible = false
	SignalBus.emit_signal("magnetButtonClick", self) # to magManager
	
