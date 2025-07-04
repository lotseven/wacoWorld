extends Node2D
class_name magnet
var angle # angle
var pos # position
var movementGrouped = false # is dis magnet part of da group of mags da playa is movin around
var glow # da glow
var player # da playa
var atch # is this magnet attached to an object or not bool

var selected = false

func _ready():
	player = get_tree().get_first_node_in_group("player")
	rotation_degrees = angle
	global_position = pos # pos is passed in, wont change
	glow = $glow
	glow.visible = false

func _process(delta: float) -> void:
	if selected: glow.visible = true
	else: glow.visible = false
