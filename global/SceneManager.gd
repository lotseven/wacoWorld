extends Node
var curScene
var pInst
var pScen
var basePath
@export var loadTestingScene = true

func _ready():
	pScen = load("res://player/player.tscn")
	basePath = "res://testingScenes/baseScene.tscn"
	if !loadTestingScene:
		switchScene(basePath)
	else: 
		curScene = get_tree().current_scene
		var spot = hasSpot(curScene)
		if spot: $player.global_position = spot.global_position


func switchScene(scenePath):
	call_deferred('deferredSwitch', scenePath)

func deferredSwitch(scenePath):
	if curScene != null: curScene.queue_free()
	var nextScene = load(scenePath).instantiate()
	curScene = nextScene
	$sceneContainer.add_child(nextScene) # Add it below the UI/player
	var spot = hasSpot(nextScene)
	if spot:
		$player.global_position = spot.global_position


func hasSpot(node: Node) -> Node:
	for child in node.get_children():
		if child is playerStartPos:
			return child
	return null
