extends CharacterBody2D
class_name player

const SPEED := 12000.0
const JUMP_FORCE := -300.0
const GRAVITY := 980.0 #change to force
const MASS = 100.0
var camOffset = 600
var camOffSaved = 600
@onready var sprite = $Sprite2D
@onready var groundHitbox = $groundHitbox
@onready var magHitbox = $magHitbox
var activeMagnetList
var magAcc = 3
var maxMags = 3
var footstepSound = "res://sounds/playerSfx/steps.mp3"

func _ready() -> void:
	$magManager.connect("magChange", Callable(self, "updateMagMovement"))
	camOffset = camOffSaved
	$camera.offset = Vector2(0,-camOffset)
	$camera.position = position
	activeMagnetList = $magManager.movementMags
	switch_to_grounded()

func _physics_process(delta):
	if activeMagnetList == []:
		switch_to_grounded()
		groundedMovement(delta)
	else: 
		switch_to_magnet()
		magnetMovement(delta)

func groundedMovement(delta):
	velocity.y += GRAVITY * delta
	var input_direction := 0.0
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"): # both moving and sound handling
		if Input.is_action_pressed("left"): # stupid idiot checking again 😂 bruh really wants to know
			input_direction -= 1.0
		elif Input.is_action_pressed("right"):
			input_direction += 1.0
		if is_on_floor(): FxManager.startLoopedFx('steps', footstepSound)
		else: FxManager.stopLoopedFx('steps')
	else: FxManager.stopLoopedFx('steps')
	velocity.x = input_direction * SPEED * delta
	move_and_slide()
	if input_direction != 0:
		$looks.flip_h = input_direction < 0
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_FORCE

func updateMagMovement():
	activeMagnetList = $magManager.movementMags

func magnetMovement(delta):
	#for m in activeMagnetList:
		#var vec2mag = (global_position - m.global_position) # vector from p to mag
		#var forceUnitVector = vec2mag.normalized * $magManager.magForce
		#var massDiv = forceUnitVector/MASS

	var moveTo := get_midpoint(activeMagnetList)
	var direction := moveTo - position
	var distance := direction.length()
	if distance > 1.0:
		var speed : float = distance * magAcc
		var vel := direction.normalized() * speed
		move_and_collide(vel * delta)

func get_midpoint(node_list: Array) -> Vector2:
	var sum := Vector2.ZERO
	var count := 0
	for node in node_list:
		if node and node.has_method("get_global_position"):
			sum += node.global_position
			count += 1
	if count == 0:
		return Vector2.ZERO
	return sum / count

# toggle hitboxes
func switch_to_grounded():
	groundHitbox.disabled = false
	magHitbox.disabled = true

func switch_to_magnet():
	groundHitbox.disabled = true
	magHitbox.disabled = false
