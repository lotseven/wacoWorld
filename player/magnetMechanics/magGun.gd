extends Node2D
var bulletList
@export var maxBullets = 3
var aimMode = false
var rightHoldTime := 0.0
const AIM_HOLD_THRESHOLD := 0.3 # seconds

var pointerCoords # coordinates of cursor, vector pointing to cursor from player, angle of that vector
var pointerVec
var pointerAngle

var projContainer # container for the existing fired projectiles (probably only contains 1 at any time)
@export var projectile: PackedScene

var player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	projContainer = $projContainer
	#projectile = "res://player/magnetMechanics/magnetProjectile.tscn"
	
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
			handleFiring()
		aimMode = false
		SignalBus.emit_signal("updateAimArrowVisibility", false)
		
func handleFiring():
	print("Aim mode deactivated: fire with vector: ", pointerVec, " (printed from magGun.gd)")
	# the vector x componant is expected behavior
	# vectory y componant has positive y = down direction, since all graphics programs
	# are kind of retarded in that way but thats ok i guess
	
	var newProjectile = projectile.instantiate()
	newProjectile.position = player.position
	newProjectile.myVec = pointerVec
	newProjectile.myAngle = pointerAngle - 90
	projContainer.add_child(newProjectile)
	
func clickRcvL(coords): #does nothing rn
	#print("left clicked @: ", coords, " (printed from magGun.gd)")
	pass
	
func clickRcvR(coords): #does nothing rn
	#print("right clicked @: ", coords, " (printed from magGun.gd)")
	pass
