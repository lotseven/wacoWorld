extends Node2D

signal clickLeft(position: Vector2)
signal clickRight(position: Vector2)

@export var myScale = 1.2

var isLeftHeld := false
var isRightHeld := false

func _ready():
	scale.x = myScale
	scale.y = myScale
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(_delta):
	position = get_global_mouse_position()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			isLeftHeld = event.pressed
			if event.pressed:
				on_left_click(event.position)
				
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			isRightHeld = event.pressed
			if event.pressed:
				on_right_click(event.position)

func _physics_process(_delta):
	if isLeftHeld:
		on_left_hold(position)
	if isRightHeld:
		on_right_hold(position)

func on_left_click(position: Vector2):
	clickLeft.emit(position)

func on_right_click(position: Vector2):
	clickRight.emit(position)

func on_left_hold(position: Vector2):
	#print("held L")
	pass

func on_right_hold(position: Vector2):
	#print("held r")
	pass
