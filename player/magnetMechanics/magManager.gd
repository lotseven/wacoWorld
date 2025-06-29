extends Node2D
@export var maxMags = 3
var aimMode = false
var rightHoldTime := 0.0
const AIM_HOLD_THRESHOLD := 0.15 # seconds
var movementMags = [] # variable to store a list of magnets which will be used to move around

var pointerCoords # coordinates of cursor, vector pointing to cursor from player, angle of that vector
var pointerVec
var pointerAngle

var projContainer # container for the existing fired projectiles (probably only contains 1 at any time)
@export var projectile: PackedScene
var magContainer
@export var magnet: PackedScene
var player

func _ready() -> void:
	SignalBus.connect("createMagnet", Callable(self, "handleMagnetCreation")) # connection ...
	SignalBus.connect("magnetButtonClick", Callable(self, "handlePlayerMagnets")) # connection ...
	
	player = get_tree().get_first_node_in_group("player") # player noad !!
	projContainer = $projContainer # self explanatory
	magContainer = $magContainer
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
		var curMags = magContainer.get_child_count()
		if rightHoldTime >= AIM_HOLD_THRESHOLD and !aimMode and curMags < maxMags:
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
	var newMagnet = magnet.instantiate()
	newMagnet.pos = pos
	newMagnet.angle = angle
	magContainer.add_child(newMagnet)

func handlePlayerMagnets(magnet):
	if movementMags.has(magnet):
		movementMags.erase(magnet)
		print("magnet removed")
		magnet.grouped = false
	else: 
		movementMags.append(magnet)
		print("magnet added")
		magnet.grouped = true
	
	
