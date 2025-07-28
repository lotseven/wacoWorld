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
	get_tree().root.call_deferred("add_child", nextScene)
