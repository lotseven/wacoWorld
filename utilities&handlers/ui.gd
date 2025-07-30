extends CanvasLayer
var aimArrow
var player
var pointerCoords 
var pointerVec 
var pointerAngle

func _ready() -> void: 
	$delModeIndic.visible = false     
	$aimModeIndic.visible = false                     
	$groupModeIndic.visible = false
	player = get_tree().get_first_node_in_group("player")
	aimArrow = get_node("aimArrow")
	SignalBus.connect("updateAimArrowVisibility", Callable(self, "setAimArrowVisibility"))	
	SignalBus.connect("switchToRecall", Callable(self, "enterRecallMode"))	
	SignalBus.connect("switchToGrouping", Callable(self, "enterGroupingMode"))
	SignalBus.connect("updateCharacterTalking", Callable(self, "updateCharacterTalking"))
		
	
func setAimArrowVisibility(x):
	$aimModeIndic.visible = x
	
func enterRecallMode(x):
	$delModeIndic.visible = x

func enterGroupingMode(x):
	$groupModeIndic.visible = x


func _process(delta: float) -> void:
	$fpsCounter.text = str(Engine.get_frames_per_second()) # display fps to track performance of stuff
	if Pointer and player:
		pointerCoords = Pointer.position
		pointerVec = (pointerCoords - player.position).normalized()
		pointerAngle = rad_to_deg(atan2(pointerVec[1], pointerVec[0])) + 90
		aimArrow.rotation_degrees = pointerAngle

func updateCharacterTalking(x): # if the character is in range of a dialogic zone sorta
	#if x:
		#print("IM A CHARACTER AND IM TALKING")
		
	pass
