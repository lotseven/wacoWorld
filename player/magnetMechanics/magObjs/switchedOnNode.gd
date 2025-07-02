extends Node
class_name switchedOnNode
var mag = preload("res://player/magnetMechanics/magnet.tscn")
var magPos
var magAngle

var origPos # original position of the staticDetector 
var origRot # original rotation of the staticDetector

func _ready() -> void:
	origPos = self.position
	origRot = self.rotation_degrees
	var p = magPos
	var a = magAngle
	magAtch(p, a)
func magAtch(pos, angle):
	var newMag = mag.instantiate()
	var offset = origPos - self.position
	var rotOffset = origRot - self.rotation_degrees
	
	newMag.pos = pos# - origPos + offset
	newMag.angle = angle + rotOffset
	
	# DOESNT QUITE WORK BUT ITS WAY BETTER
	RigidBody2D
	newMag.atch = self
	self.add_child(newMag)
