extends Node2D
var bulletList
@export var maxBullets = 3
var aimMode = false
var rightHoldTime := 0.0
const AIM_HOLD_THRESHOLD := 0.3 # seconds
var pointerCoords
var pointerVec
var pointerAngle



func _ready() -> void:
	Pointer.clickLeft.connect(clickRcvL)
	Pointer.clickRight.connect(clickRcvR)
	SignalBus.emit_signal("updateAimArrowVisibility", false)
	# YOU CAN ALSO DO Pointer.isLeftHeld & Pointer.isRightHeld for mouse ins
	
func _process(delta: float) -> void:
	manageAimingMode(delta)
	pointerCoords = Pointer.position
	pointerVec = (pointerCoords - global_position).normalized()
	pointerAngle = rad_to_deg(atan2(pointerVec[1], pointerVec[0])) + 180
	
func manageAimingMode(delta: float) -> void:
	if Pointer.isRightHeld: # waits for half a second of holding before entering aim mode
		rightHoldTime += delta
		if rightHoldTime >= AIM_HOLD_THRESHOLD and !aimMode:
			aimMode = true
			SignalBus.emit_signal("updateAimArrowVisibility", true)
			print("Aim mode activated", " (printed from magGun.gd)")
			
	else: # if player releases aim button, magnet should fire off
		rightHoldTime = 0.0
		if aimMode:
			handleAimRelease()
		aimMode = false
		SignalBus.emit_signal("updateAimArrowVisibility", false)
		
func handleAimRelease():
	# the vector x componant is expected behavior
	# vectory y componant has positive y = down direction, since all graphics programs
	# are kind of retarded in that way but thats ok i guess
	
	# this all happens in ui now btw. which makes sense since its a ui, i suppose
	print("Aim mode deactivated: fire with vector: ", pointerVec, " (printed from magGun.gd)")
	
	
func clickRcvL(coords): #does nothing rn
	#print("left clicked @: ", coords, " (printed from magGun.gd)")
	pass
	
func clickRcvR(coords): #does nothing rn
	#print("right clicked @: ", coords, " (printed from magGun.gd)")
	pass
