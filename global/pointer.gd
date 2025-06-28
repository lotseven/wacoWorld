extends Node2D
signal clickCoords(Vector2)
@export var myScale = 1.2

func _ready():
	scale.x = myScale
	scale.y = myScale
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)  # Hide default cursor

func _process(delta):
	self.position = get_global_mouse_position()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		#print("Mouse clicked at: ", event.position, "+ (printed from pointer.gd)")
		doClickAnimation()
		clickCoords.emit(event.position)
		
func doClickAnimation():
	pass
