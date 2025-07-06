extends CharacterBody2D
class_name player

# beeg constant number
const SPEED := 12000.0
const JUMP_FORCE := -450.0
const GRAVITY := 980.0 #change to force
const MASS = 80

# cam stuff
var camOffset = 900
# references to children or other nodes
@onready var sprite = $Sprite2D
#@onready var groundHitbox = $hitbox

# magnet numbers
var maxMags = 3
const MAGNET_FORCE = 290000.0
const DRAG_COEFFICIENT = 1
const SNAP_DISTANCE = 40.0
var distanceScale = 1
var distScaleConst = 60000
var slopeScale = 3 # the base of the log that determines the scaling of speed/distancea, smaller the faster it falls off
var gravScale = 1 # gravity is divided by this when youre doin magnet stuff
var MAX_SPEED = 1000.0
var jumping = false # should check if player is mid-jump

# sound
var footstepSound = "res://sounds/playerSfx/steps.mp3"

# moving on magnets stuff
var flingMag 
var wantsToPull = false
var wantsToPush = false

func _ready() -> void:
	$magManager.connect("magChange", Callable(self, "updateMagMovement"))
	$camera.offset = Vector2(0,-camOffset)
	$camera.position = position

func _physics_process(delta):
		updateMovementIntent()
		movement(delta)

func movement(delta):
	groundedMovement(delta)
	magnetMovement(delta)
	friction(delta)
	move_and_slide()

func groundedMovement(delta):
	var inputDir = 0.0
	var amIMagMoving = !((!wantsToPull and !wantsToPush) or ((wantsToPull or wantsToPush) and flingMag == null))	
	if !amIMagMoving: # disables movement
		if Input.is_action_pressed("left"):
			if abs(velocity.x) < abs(-SPEED * delta): # so u cant slow down by holding left or right when flyin around
				velocity.x = -SPEED * delta 
			inputDir = -1.0
		elif Input.is_action_pressed("right"):
			if abs(velocity.x) < abs(SPEED * delta):
				velocity.x = SPEED * delta 
			inputDir = 1.0
		else: # instant friction (idk if non-instant is good)
			if is_on_floor():
				velocity.x = 0 # big ahh if statement 😂 bro really in the mood to Check Conditions

	#jumpin
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_FORCE
		jumping = true
	if !is_on_floor() and (wantsToPull or wantsToPush) and flingMag:
		jumping = false
		
	#gravity
	if not is_on_floor() and !wantsToPull and !wantsToPush:
		velocity.y += GRAVITY * delta
	elif not is_on_floor(): 
		velocity.y += GRAVITY/gravScale * delta

	if is_on_floor() and (Input.is_action_pressed('left') or Input.is_action_pressed("right")): FxManager.startLoopedFx('steps', footstepSound)
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
		
		if wantsToPull: #
			pull(distScaleConst, dist, vecToMag, delta)
			snapToMag(dist)
		elif wantsToPush: # pulling on da mags. i hate it
			push(distScaleConst, dist, vecToMag, delta)
		
	elif flingMag:
		flingMag.pulledOrPushed = false

			
func updateMovementIntent():
	flingMag = $magManager.flingMag
	wantsToPull = Input.is_action_pressed('pull')
	wantsToPush = Input.is_action_pressed('push')

func friction(delta):
	velocity -= velocity * DRAG_COEFFICIENT * delta
	if is_on_floor():
		velocity -= velocity * 2 * DRAG_COEFFICIENT * delta

func snapToMag(dist):
	if dist < SNAP_DISTANCE: # needs to be better later
		velocity = Vector2.ZERO

func pull(distScaleConst, dist, vecToMag, delta):
	var direction = vecToMag.normalized()
	var magForce = direction * MAGNET_FORCE * abs(70000/(dist**2))
	var acceleration = magForce / MASS
	velocity += acceleration * delta
	flingMag.pulledOrPushed = true

func push(distScaleConst, dist, vecToMag, delta):
	var direction = vecToMag.normalized() * -1
	var magForce = direction * MAGNET_FORCE * abs(distScaleConst/(dist**2)) / 3
	var acceleration = magForce / MASS
	velocity += acceleration * delta
	flingMag.pulledOrPushed = true
