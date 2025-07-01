extends Node2D
var angle
var pos
var grouped = false
var glow
var player 
var atch # is this magnet attached to an object or not
var atchPos
var offset 

func _ready():
	player = get_tree().get_first_node_in_group("player")
	rotation_degrees = angle
	position = pos # pos is passed in, wont change
	glow = $glow
	glow.visible = false
	

func buttonPressed() -> void:
	#if player.get_node('magManager').magClickMode == 'activating':
		if !grouped: # if the magnet is being joined into the group, make the thing visible
			glow.visible = true
		else: 
			glow.visible = false
		SignalBus.emit_signal("magnetButtonClick", self) # to magManager
	
func _process(delta: float) -> void: # THIS *SHOULD* APPLY TO ALL MAGOBJS
	if atch != null:
		offset = atchPos - atch.global_position
		position = pos - offset
