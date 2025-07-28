extends Node
var curScene
var pInst
var pScen
var basePath
func _ready():
	pScen = load("res://player/player.tscn")
	basePath = "res://testingScenes/baseScene.tscn"
	switchScene(basePath)

func switchScene(scenePath):
	call_deferred('deferredSwitch', scenePath)

func deferredSwitch(scenePath):
	if curScene != null: curScene.free()
	var nextScene = load(scenePath).instantiate()
	curScene = nextScene
	self.add_child(nextScene)
	var spot = hasSpot(nextScene)
	if spot: $player.global_position = spot.global_position
	MagnetContainer.clear()
	MagnetContainer.groupsUpdate()

func hasSpot(node: Node) -> Node:
	for child in node.get_children():
		if child is playerStartPos:
			return child
	return null
