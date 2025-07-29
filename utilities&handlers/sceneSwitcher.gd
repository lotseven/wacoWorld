extends Area2D

@export var nextScene : String
@export var automatic : bool
@export var height : float
@export var width : float
var hitbox 

func _ready():
	hitbox = $hitbox
	assignExportedValues()

func assignExportedValues():
	hitbox.shape.size.x = width
	hitbox.shape.size.y = height

func _on_body_entered(body: Node2D) -> void:
	if body is player:
		if automatic:
			SceneManager.switchScene(nextScene)
			SignalBus.emit_signal("sceneSwitched")
