extends CharacterBody2D
class_name player

# beeg constant number
const SPEED := 12000.0
const JUMP_FORCE := -350.0
const GRAVITY := 980.0 #change to force
const MASS = 80

# cam stuff
var camOffset = 600
var camOffSaved = 600
# references to children or other nodes
@onready var sprite = $Sprite2D
#@onready var groundHitbox = $hitbox

# magnet numbers
var maxMags = 3
const MAGNET_FORCE = 240000.0
const DRAG_COEFFICIENT = 6
const SNAP_DISTANCE = 35.0
var distanceScale = 1
var distScaleConst = 300 # since distance scale must inversely relate to speed, i use 1/dist, which might be really small. this scales that back up
var slopeScale = 1.5 # the base of the log that determines the scaling of speed/distancea, smaller the faster it falls off
var gravScale = 1 # gravity is divided by this when youre doin magnet stuff
var MAX_SPEED = 1000.0

# sound
var footstepSound = "res://sounds/playerSfx/steps.mp3"

# moving on magnets stuff
var flingMag 
var wantsToPull = false
var wantsToPush = false

func _ready() -> void:
	$magManager.connect("magChange", Callable(self, "updateMagMovement"))
	camOffset = camOffSaved
	$camera.offset = Vector2(0,-camOffset)
	$camera.position = position

func _physics_process(delta):
		updateMovementIntent()
		movement(delta)

func movement(delta):
	groundedMovement(delta)
	magnetMovement(delta)
	airFriction(delta)
	move_and_slide()

func groundedMovement(delta):
	var inputDir = 0.0
	var airFactor = 1.0
	if !is_on_floor(): airFactor = .5
	
	if Input.is_action_pressed("left"):
		velocity.x = -SPEED * delta * airFactor
		inputDir = -1.0
	elif Input.is_action_pressed("right"):
		velocity.x = SPEED * delta * airFactor
		inputDir = 1.0
		
	else: # instant friction (idk if non-instant is good)
		if is_on_floor() and ((!wantsToPull and !wantsToPush) or ((wantsToPull or wantsToPush) and flingMag == null)):
			velocity.x = 0 # big ahh if statement 😂 bro really in the mood to Check Conditions

	#jumpin
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_FORCE
		
	#gravity
	if not is_on_floor() and !wantsToPull and !wantsToPush:
		velocity.y += GRAVITY * delta
	elif not is_on_floor(): 
		velocity.y += GRAVITY/gravScale * delta

		if is_on_floor(): FxManager.startLoopedFx('steps', footstepSound)
		else: FxManager.stopLoopedFx('steps')

	
	#flip sprite
	if inputDir != 0:
		$looks.flip_h = inputDir < 0
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_FORCE

func magnetMovement(delta):
	if flingMag and (wantsToPull or wantsToPush):
		var vecToMag = flingMag.global_position - global_position
		var dist = vecToMag.length()
		distanceScale = 1/dist
		
		if dist < SNAP_DISTANCE: # snaps position to the magnet if you click and get real close
			# needs to be reworked to be smarter, can stick you into blocks rn 
			global_position = flingMag.global_position
			velocity = Vector2.ZERO
			flingMag = null		

		if wantsToPull: # pulling on da mags
			var direction = vecToMag.normalized()
			var magForce = direction * MAGNET_FORCE * (log(1 + (distScaleConst / dist))/log(slopeScale))
			var acceleration = magForce / MASS
			velocity += acceleration * delta
			
		elif wantsToPush: # pulling on da mags
			var direction = vecToMag.normalized() * -1
			var magForce = direction * MAGNET_FORCE * (log(1 + (distScaleConst / dist))/log(slopeScale))
			var acceleration = magForce / MASS
			velocity += acceleration * delta
			
		#var drag_strength = DRAG_COEFFICIENT * vecToMag.length() #* velocity.length()
		#var drag = velocity.normalized() * drag_strength
		#velocity -= drag * delta

func airFriction(delta):
	if !is_on_floor():
		velocity -= velocity/85
		
func updateMovementIntent():
	flingMag = $magManager.flingMag
	wantsToPull = Input.is_action_pressed('pull')
	wantsToPush = Input.is_action_pressed('push')
