extends Node
class_name switchedOnNode
var mag = preload("res://player/magnetMechanics/magnet.tscn")
var magPos
var magAng
var atchPos

func spawnMagnet():
	var newMag = mag.instantiate()
	newMag.pos = magPos
	newMag.angle = magAng + 180
	newMag.atch = self
	newMag.atchPos = atchPos
	MagnetContainer.add_child(newMag)
