extends RigidBody2D
class_name genPurposeMagnetable
var mag = preload("res://player/magnetMechanics/utility/magnet.tscn")
var origPos # original position of the staticDetector 
var origRot # original rotation of the staticDetector
var groups = []

func _ready() -> void:
	origPos = self.position
	origRot = self.rotation_degrees
	SignalBus.connect("groupingHasChanged", Callable(self, 'groupingChange'))
	
func magAtch(pos, angle):
	var newMag = mag.instantiate()
	var offset = origPos - self.position
	var rotOffset = origRot - self.rotation_degrees
	
	newMag.pos = pos# - origPos + offset
	newMag.angle = angle + rotOffset
	
	newMag.atch = self
	self.add_child(newMag)
	MagnetContainer.magList.append(newMag)
	
func groupingHasChanged():
	for node in get_children():
		if node is magnet:
			groups = node.groups # MAKE IT SO THAT MAGOBJS CAN ONLY HAVE 1 MAGNET
