extends Node2D
var maxMags
var aimMode = false
var groupMode = false
var rightHoldTime := 0.0
const AIM_HOLD_THRESHOLD := 0.15 # seconds
var movementMags = [] # variable to store a list of magnets which will be used to move around
var selectables = [] # list of which magnets can be currently selected

var pointerCoords # coordinates of cursor, vector pointing to cursor from player, angle of that vector
var pointerVec
var pointerAngle

var projContainer # container for the existing fired projectiles (probably only contains 1 at any time)
@export var projectile: PackedScene
@export var magnet: PackedScene
@onready var magDetec = $magnetDetection
@onready var lineLogic = $lineLogic

var player
signal magChange # calls a function in player to update magnet list and handle movement
var magClickMode = 'activating' # choose whether to be activating, recalling, grouping mags

var createDeleteSFX = "res://sounds/playerSfx/button-202966.mp3"
var groupingSFX = "res://sounds/playerSfx/button-4-214382.mp3"
var selMag # what magnet the player gets flung 2
var recallSoundTracker # dont worry about this little variable :)

var groupingClicked = false
var numOfGroups = 0
var maxGroups = 3

func _ready() -> void:
	SignalBus.connect("createMagnet", Callable(self, "handleMagnetCreation")) # connection ...
	SignalBus.connect("magnetButtonClick", Callable(self, "handleMagClicks")) # connection ...
	
	player = get_tree().get_first_node_in_group("player") # player noad !!
	projContainer = $projContainer # self explanatory

	maxMags = player.maxMags # gets max magnet count
	
func _process(delta: float) -> void:
	if !DialogManager.isTalking:
		if MagnetContainer.magList.size() < maxMags: manageAimingMode(delta)
		manageGroupingMode()
		updatePointer()
		rotateMagShape()
		if !aimMode: selMag = selectMagnet()
		if groupMode: handleGrouping()
		recallMags()
	
func manageAimingMode(delta: float) -> void: # goes in and out of aiming mode
	if Input.is_action_pressed('aim'): # waits for half a second of holding before entering aim mode
		var curMags = MagnetContainer.magList.size()
		aimMode = true
		SignalBus.emit_signal("updateAimArrowVisibility", true)
	elif Input.is_action_just_released("aim"): # if player releases aim button, magnet should fire off
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
		
	#else: 
		#var newMagnet = magnet.instantiate()
		#newMagnet.pos = pos
		#newMagnet.angle = angle
		#MagnetContainer.add_child(newMagnet)
		#MagnetContainer.magList.append(newMagnet)
		
	FxManager.playFx(createDeleteSFX)	
	SignalBus.emit_signal('updateNodeMagnets')	

func updatePointer():
	pointerCoords = Pointer.global_position
	pointerVec = (pointerCoords - global_position).normalized()
	pointerAngle = rad_to_deg(atan2(pointerVec[1], pointerVec[0])) + 180

func onMagDetectionEntered(m) -> void:
	if m is magnet:
		if !selectables.has(m):
			selectables.append(m)

func onMagDetectionExited(m) -> void:
	if m is magnet:
		if selectables.has(m):
			selectables.erase(m)

func rotateMagShape():
	magDetec.rotation_degrees = pointerAngle + 180

func selectMagnet():
	var mag
	if selectables.size()>0:
		mag = selectables[0]
		if selectables.size() > 1:
			var potentialMagPos = mag.global_position
			for m in selectables:
				if (pointerCoords - m.global_position).length() < (pointerCoords - potentialMagPos).length():
					potentialMagPos = m.global_position
					mag = m
		if mag and mag.isOnScreen(): mag.selected = true # mag should, at this point, be something
	for m in MagnetContainer.magList: # deselects all magnets that shouldnt be selected
		if m!= mag:
			m.selected = false
			m.pulledOrPushed = false
	return mag
	
func recallMags():
	recallSoundTracker = false
	if Input.is_action_pressed("recall"):
		for m in MagnetContainer.magList:
			movementMags.erase(m)
			MagnetContainer.magList.erase(m)
			m.queue_free()
			recallSoundTracker = true
			numOfGroups = 0
		SignalBus.emit_signal('updateNodeMagnets')
		SignalBus.emit_signal('groupingHasChanged')
		lineLogic.recallAll()
	if recallSoundTracker:
		FxManager.playFx(createDeleteSFX)

func manageGroupingMode(): # goes in and out of aiming mode
	if Input.is_action_just_pressed('group'): 
		groupMode = true
		SignalBus.emit_signal('switchToGrouping', true)
	if Input.is_action_just_released('group'): # if player releases group button, you exit aimMode
		groupMode = false
		lineLogic.endLine()
		SignalBus.emit_signal('switchToGrouping', false)

func handleGrouping():
	if Input.is_action_just_pressed('lClick'): 
		groupingClicked = true
		if selMag: 
			numOfGroups += 1
	if groupingClicked and selMag and numOfGroups < maxGroups + 1: # so if youve clicked or hovered on a new magnet
		if !selMag.groups.has(numOfGroups):
			lineLogic.addPoint(selMag.global_position)
			selMag.groups.append(numOfGroups)
	if Input.is_action_just_released('lClick'): 
		groupingClicked = false
		lineLogic.endLine()
		SignalBus.emit_signal('groupingHasChanged')
