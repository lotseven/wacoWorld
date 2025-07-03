extends Node2D
var maxMags
var magForce := 100
var aimMode = false
var rightHoldTime := 0.0
const AIM_HOLD_THRESHOLD := 0.15 # seconds
var movementMags = [] # variable to store a list of magnets which will be used to move around

var pointerCoords # coordinates of cursor, vector pointing to cursor from player, angle of that vector
var pointerVec
var pointerAngle

var projContainer # container for the existing fired projectiles (probably only contains 1 at any time)
@export var projectile: PackedScene
@export var magnet: PackedScene
var player
signal magChange # calls a function in player to update magnet list and handle movement
var magClickMode = 'activating' # choose whether to be activating, recalling, grouping mags

var createDeleteSFX = "res://sounds/playerSfx/button-202966.mp3"
var groupingSFX = "res://sounds/playerSfx/button-4-214382.mp3"

func _ready() -> void:
	SignalBus.connect("createMagnet", Callable(self, "handleMagnetCreation")) # connection ...
	SignalBus.connect("magnetButtonClick", Callable(self, "handleMagClicks")) # connection ...
	
	player = get_tree().get_first_node_in_group("player") # player noad !!
	projContainer = $projContainer # self explanatory
	SignalBus.emit_signal("updateAimArrowVisibility", false)
	SignalBus.emit_signal("switchToRecall", false)
	# YOU CAN ALSO DO Pointer.isLeftHeld & Pointer.isRightHeld for mouse ins
	
	maxMags = player.maxMags # gets max magnet count
	
func _process(delta: float) -> void:
	manageAimingMode(delta)
	pointerCoords = Pointer.position
	pointerVec = (pointerCoords - global_position).normalized()
	pointerAngle = rad_to_deg(atan2(pointerVec[1], pointerVec[0])) + 180
	handleMagnetRecalls()
	
func manageAimingMode(delta: float) -> void: # goes in and out of aiming mode
	if Pointer.isRightHeld: # waits for half a second of holding before entering aim mode
		rightHoldTime += delta
		var curMags = MagnetContainer.magList.size()
		if rightHoldTime >= AIM_HOLD_THRESHOLD and !aimMode and curMags < maxMags:
			aimMode = true
			SignalBus.emit_signal("updateAimArrowVisibility", true)
			#print("Aim mode activated", " (printed from magGun.gd)")
			
	else: # if player releases aim button, magnet should fire off
		rightHoldTime = 0.0
		if aimMode:
			handleFiring()
		aimMode = false
		SignalBus.emit_signal("updateAimArrowVisibility", false)
		
func handleFiring(): # when player releases, it fires 
	var newProjectile = projectile.instantiate()
	newProjectile.position = player.position
	newProjectile.myVec = pointerVec
	newProjectile.myAngle = pointerAngle - 90
	projContainer.add_child(newProjectile)
	
func handleMagnetCreation(object, pos, angle):
	if object is staticBodyDetection: 
		object.magAtch(pos, angle) # HERE IS ERROR SOMEWHERE
	elif object is switchedOnNode:
		object.magAtch(pos, angle)
	elif object is genPurposeMagnetable:
		object.magAtch(pos, angle)
	else: 
		var newMagnet = magnet.instantiate()
		newMagnet.pos = pos
		newMagnet.angle = angle
		MagnetContainer.add_child(newMagnet) # UNLESS ITS THE GROUND !!!
		MagnetContainer.magList.append(newMagnet)
	print(MagnetContainer.magList)
	FxManager.playFx(createDeleteSFX)	

func handleMagClicks(magnet):
	match magClickMode:
		'activating': # IF YOUR CLICK IS IN ACTIVATION MODE
			if movementMags.has(magnet):
				movementMags.erase(magnet)
				print("magnet removed")
				magnet.grouped = false
			else: 
				movementMags.append(magnet)
				print("magnet added")
				magnet.grouped = true
			magChange.emit()
			FxManager.playFx(groupingSFX)
		
		
		'recalling': # IF YOUR CLICK IS IN DELETION MODE
			movementMags.erase(magnet)
			MagnetContainer.magList.erase(magnet)
			magnet.queue_free()
			FxManager.playFx(createDeleteSFX)
			
func handleMagnetRecalls(): # DETECTS ENTERING & EXITING RECALL MODE
	if Input.is_action_pressed("recall"):
		if magClickMode != 'recalling':
			magClickMode = 'recalling'
			SignalBus.emit_signal("switchToRecall", true)
	else:
		if magClickMode == 'recalling':
			magClickMode = 'activating'
			SignalBus.emit_signal("switchToRecall", false)
	
