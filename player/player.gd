extends CharacterBody2D
class_name player

# beeg constant number
const SPEED := 12000.0
const JUMP_FORCE := -300.0
const GRAVITY := 980.0 #change to force
const MASS = 80

# cam stuff
var camOffset = 600
var camOffSaved = 600
# references to children or other nodes
@onready var sprite = $Sprite2D
@onready var groundHitbox = $groundHitbox
# magnet numbers
var maxMags = 3
const MAGNET_FORCE = 280000.0
const SNAP_DISTANCE = 35.0
# sound
var footstepSound = "res://sounds/playerSfx/steps.mp3"
# moving on magnets stuff
var flingMag 
var wantsToPull = false
var wantsToPush = false
var distanceScale = 1
var distScaleConst = 300 # since distance scale must inversely relate to speed, i use 1/dist, which might be really small. this scales that back up
var slopeScale = 3 # the base of the log that determines the scaling of speed/distance
func _ready() -> void:
	$magManager.connect("magChange", Callable(self, "updateMagMovement"))
	camOffset = camOffSaved
	$camera.offset = Vector2(0,-camOffset)
	$camera.position = position

func _physics_process(delta):
		updateMovementIntent()
		#groundedMovement(delta)
		#magnetMovement(delta)
		movement(delta)

func movement(delta):
	groundedMovement(delta)
	magnetMovement(delta)
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
		
	else: # friction (instant)
		if is_on_floor() and !wantsToPull and !wantsToPush:
			velocity.x = 0
	#jumpin
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_FORCE
		
	#gravity
	if not is_on_floor() and !wantsToPull and !wantsToPush:
		velocity.y += GRAVITY * delta

		if is_on_floor(): FxManager.startLoopedFx('steps', footstepSound)
		else: FxManager.stopLoopedFx('steps')

	
	#flip sprite
	if inputDir != 0:
		$looks.flip_h = inputDir < 0
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_FORCE

func magnetMovement(delta):
	if flingMag and wantsToPull:
		var vec_to_mag = flingMag.global_position - global_position
		var dist = vec_to_mag.length()
		distanceScale = 1/dist
		if dist < SNAP_DISTANCE: # snaps position to the magnet if you click and get real close
			global_position = flingMag.global_position
			velocity = Vector2.ZERO
			flingMag = null
			
		else: # 
			var direction = vec_to_mag.normalized()
			var magForce = direction * MAGNET_FORCE * (log(1 + (distScaleConst / dist))/log(slopeScale))
			print(magForce)
			var acceleration = magForce / MASS
			velocity += acceleration * delta


func updateMovementIntent():
	flingMag = $magManager.flingMag
	if Input.is_action_pressed("pull"): 
		wantsToPull = true
	else: 
		wantsToPull = false
