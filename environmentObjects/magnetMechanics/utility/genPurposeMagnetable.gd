extends RigidBody2D
class_name genPurposeMagnetable
var mag = preload("res://environmentObjects/magnetMechanics/utility/magnet.tscn")
var origPos # original position of the staticDetector 
var origRot # original rotation of the staticDetector
var groups = []
var myMags = []
var otherPositions = []

func _process(delta: float) -> void:
	#updateOtherPositions() # kind of a shitty way to do it ig # TODO fix this shit
	pass

func _ready() -> void:
	origPos = self.position
	origRot = self.rotation_degrees
	SignalBus.connect("groupingHasChanged", Callable(self, 'groupingChange'))
	SignalBus.connect("updateNodeMagnets", Callable(self, 'updateMagnetList'))
	
func magAtch(pos, angle):
	var newMag = mag.instantiate()
	var offset = origPos - self.position
	var rotOffset = origRot - self.rotation_degrees
	
	newMag.pos = pos# - origPos + offset
	newMag.angle = angle + rotOffset
	
	newMag.atch = self
	self.add_child(newMag)
	MagnetContainer.magList.append(newMag)
	
func updateMagnetList():
	myMags = []
	for child in get_children():
		if child is magnet:
			if !myMags.has(child): myMags.append(child)
	updateOtherPositions()

func groupingChange():
	if myMags == []: groups = []
	for m in myMags:
		groups = m.groups # DOESNT WORK WITH MORE THAN ONE MAG # TODO
	updateOtherPositions()

func updateOtherPositions(): 
	otherPositions = [] # reset and rebuild
	if groups != []:
		for i in groups:
			if MagnetContainer.groupedMagList.has(i):
				for k in MagnetContainer.groupedMagList[i]:
					if !myMags.has(k):
						otherPositions.append(k.global_position) # ok its rebuilt :)
			else: 
				print("Error in genPurposeMagnetable: MagnetContainer.groupedMagList is empty")
