extends Node2D
var bulletList
@export var maxBullets = 3
var aimMode = false
var rightHoldTime := 0.0
const AIM_HOLD_THRESHOLD := 0.15 # seconds

var pointerCoords # coordinates of cursor, vector pointing to cursor from player, angle of that vector
var pointerVec
var pointerAngle

var projContainer # container for the existing fired projectiles (probably only contains 1 at any time)
@export var projectile: PackedScene
var magContainer

var player

func _ready() -> void:
	SignalBus.connect("createMagnet", Callable(self, "handleMagnetCreation")) # connection ...
	player = get_tree().get_first_node_in_group("player") # player noad !!
	projContainer = $projContainer # self explanatory
	magContainer = $magContainer
	Pointer.clickLeft.connect(clickRcvL)
	Pointer.clickRight.connect(clickRcvR)
	SignalBus.emit_signal("updateAimArrowVisibility", false)
	# YOU CAN ALSO DO Pointer.isLeftHeld & Pointer.isRightHeld for mouse ins
	
func _process(delta: float) -> void:
	manageAimingMode(delta)
	pointerCoords = Pointer.position
	pointerVec = (pointerCoords - global_position).normalized()
	pointerAngle = rad_to_deg(atan2(pointerVec[1], pointerVec[0])) + 180
	
func manageAimingMode(delta: float) -> void: # goes in and out of aiming mode
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
		
func handleFiring(): # when player releases, it fires 
	print("Aim mode deactivated: fire with vector: ", pointerVec, " (printed from magGun.gd)")
	# the vector x componant is expected behavior
	# vectory y componant has positive y = down direction, since all graphics programs
	# are kind of retarded in that way but thats ok i guess
	var newProjectile = projectile.instantiate()
	newProjectile.position = player.position
	newProjectile.myVec = pointerVec
	newProjectile.myAngle = pointerAngle - 90
	projContainer.add_child(newProjectile)
	
func handleMagnetCreation(object, pos, angle):
	pass
	
func clickRcvL(coords): #does nothing rn
	#print("left clicked @: ", coords, " (printed from magGun.gd)")
	pass
	
func clickRcvR(coords): #does nothing rn
	#print("right clicked @: ", coords, " (printed from magGun.gd)")
	pass
