extends Node

var magList = [] # list of all magnet nodes
var groupedMagList = {} # dictionary: groupID -> list of magnets

func _ready():
	SignalBus.connect("groupingHasChanged", Callable(self, "groupsUpdate"))

func groupsUpdate():
	groupedMagList.clear() #remake every time
	for magnet in magList:
		for groupID in magnet.groups:
			if !groupedMagList.has(groupID):
				groupedMagList[groupID] = []
			groupedMagList[groupID].append(magnet)
# so now groupedMagList contains a bunch of lists. the groupID could be 1: this entry is a list of every magnet node in group 1
# magnets are grouped in magMagager, which rebuilds the list every time updates are made here via the signal
func clear():
	for mag in magList:
		if mag:
			mag.queue_free()
	magList = []
	groupedMagList = {}
