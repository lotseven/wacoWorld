extends CanvasLayer
var aimArrow
var player
var pointerCoords 
var pointerVec 
var pointerAngle

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	aimArrow = get_node("aimArrow")
	SignalBus.connect("updateAimArrowVisibility", Callable(self, "setAimArrowVisibility"))	
	SignalBus.connect("switchToRecall", Callable(self, "enterRecallMode"))	
	
func setAimArrowVisibility(x): # disabled
	$aimModeIndic.visible = x
	
func enterRecallMode(x):
	$delModeIndic.visible = x



func _process(delta: float) -> void:
	$fpsCounter.text = str(Engine.get_frames_per_second()) # display fps to track performance of stuff
	if Pointer and player:
		pointerCoords = Pointer.position
		pointerVec = (pointerCoords - player.position).normalized()
		pointerAngle = rad_to_deg(atan2(pointerVec[1], pointerVec[0])) + 90
		aimArrow.rotation_degrees = pointerAngle
