extends Area2D

@export var nextScene : String
@export var automatic : bool
@export var height : float
@export var width : float
var hitbox 
var playerIn = false

func _ready():
	$prompt.visible = false
	hitbox = $hitbox
	assignExportedValues()

func _process(delta: float) -> void:
	if playerIn and Input.is_action_just_released('jump'):
		switch()

func assignExportedValues():
	hitbox.shape.size.x = width
	hitbox.shape.size.y = height

func _on_body_entered(body: Node2D) -> void:
	if body is player:
		$prompt.visible = true
		playerIn = true
		SignalBus.emit_signal('updateCharacterInteracting', true, self.name)
		if automatic:
			switch()

func _on_body_exited(body: Node2D) -> void:
	if body is player:
		$prompt.visible = false
		SignalBus.emit_signal('updateCharacterInteracting', false, self.name)
		playerIn = false

func switch():
	SceneManager.switchScene(nextScene)
	SignalBus.emit_signal("sceneSwitched")	
