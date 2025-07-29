extends Node2D
class_name magnet
var angle # angle
var pos # position
var movementGrouped = false # is dis magnet part of da group of mags da playa is movin around
var glow # da glow
var redGlow # da red glow
var player # da playa
var atch # is this magnet attached to an object or not bool
var groups = []
var selected = false
var pulledOrPushed = false
var visDetect

func _ready():
	visDetect = $visDetect
	player = get_tree().get_first_node_in_group("player")
	rotation_degrees = angle
	global_position = pos # pos is passed in, wont change
	glow = $glow
	redGlow = $redGlow
	redGlow.visible = false
	glow.visible = false
	add_to_group("magnets")

func _process(delta: float) -> void:
	if selected: glow.visible = true
	else: glow.visible = false
	if pulledOrPushed: redGlow.visible = true
	else: redGlow.visible = false
	$groupsLabel.text = str(groups)
	
func isOnScreen():
	return visDetect.is_on_screen()
