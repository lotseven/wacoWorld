extends CharacterBody2D
class_name player

# beeg constant number
const SPEED := 12000.0
const JUMP_FORCE := -450.0
const GRAVITY := 980.0 #change to force
const MASS = 80

# cam stuff
var camOffset = 900

# references to children or other nodes or sprites
# also i signed in on a nother computer hiii
# holden hiiiiii
@onready var sprite = $Sprite2D
var footstepSound = "res://sounds/playerSfx/steps.mp3"
var checkpoint # da checkpoint

# magnet numbers
var maxMags = 3
const MAGNET_FORCE = 390000.0
const DRAG_COEFFICIENT = 1
const SNAP_DISTANCE = 60.0
var distanceScale = 1
var distScaleConst = 60000
var slopeScale = 3 # the base of the log that determines the scaling of speed/distancea, smaller the faster it falls off
var gravScale = 1 # gravity is divided by this when youre doin magnet stuff
var jumping = false # should check if player is mid-jump

# moving on magnets stuff
var selMag 
var wantsToPull = false
var wantsToPush = false
var maxSpeed = 2000

func _ready() -> void:
	checkpoint = global_position
	$magManager.connect("magChange", Callable(self, "updateMagMovement"))
	SignalBus.connect('hurtPlayer', Callable(self, 'hurtPlayer'))
	SignalBus.connect('updateCheckpoint', Callable(self, 'updateCheckpoint'))
	$camera.offset = Vector2(0,-camOffset)
	$camera.position = position
	

func _physics_process(delta):
		updateMovementIntent()
		movement(delta)

func movement(delta):
	groundedMovement(delta)
	if !$magManager.groupMode: magnetMovement(delta)
	friction(delta)
	capSpeed()
	move_and_slide()

func groundedMovement(delta):
	var inputDir = 0.0
	var amIMagMoving = !((!wantsToPull and !wantsToPush) or ((wantsToPull or wantsToPush) and selMag == null))# big ahh if statement 😂 bro really in the mood to Check Conditions
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
				velocity.x = 0 

	#jumpin
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_FORCE
		jumping = true
	if !is_on_floor() and (wantsToPull or wantsToPush) and selMag:
		jumping = false
		
	#gravity
	if not is_on_floor() and !wantsToPull and !wantsToPush:
		velocity.y += GRAVITY * delta
	elif not is_on_floor(): 
		velocity.y += GRAVITY/gravScale * delta

	if is_on_floor() and velocity != Vector2.ZERO and (Input.is_action_pressed('left') or Input.is_action_pressed("right")): 
		FxManager.startLoopedFx('steps', footstepSound)# long ahh if statement 😂 bro really wanna Investigate Conditions
	else: FxManager.stopLoopedFx('steps')

	
	#flip sprite
	if inputDir != 0:
		$looks.flip_h = inputDir < 0
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_FORCE
	
func magnetMovement(delta):
	if selMag and (wantsToPull or wantsToPush):
		var vecToMag = selMag.global_position - global_position
		var dist = vecToMag.length()
		distanceScale = 1/dist
		
		if wantsToPull: #
			pull(distScaleConst, dist, vecToMag, delta)
			snapToMag(dist)
		elif wantsToPush: # pulling on da mags. i hate it
			push(distScaleConst, dist, vecToMag, delta)
		
	elif selMag:
		selMag.pulledOrPushed = false


func updateMovementIntent():
	selMag = $magManager.selMag
	wantsToPull = Input.is_action_pressed('lClick')
	wantsToPush = Input.is_action_pressed('rClick')

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
	selMag.pulledOrPushed = true

func push(distScaleConst, dist, vecToMag, delta):
	var direction = vecToMag.normalized() * -1
	var magForce = direction * MAGNET_FORCE * abs(distScaleConst/(dist**2)) / 3
	var acceleration = magForce / MASS
	velocity += acceleration * delta
	selMag.pulledOrPushed = true
	
func hurtPlayer(spike):
	velocity = Vector2.ZERO
	global_position = checkpoint

func updateCheckpoint(c):
	var newPos = c.global_position
	newPos.y -= 100
	checkpoint = newPos
	
func capSpeed():
	if abs(velocity.y) >= maxSpeed: velocity.y = clamp(velocity.y, -maxSpeed, maxSpeed)
	if abs(velocity.x) >= maxSpeed: velocity.x = clamp(velocity.x, -maxSpeed, maxSpeed)
