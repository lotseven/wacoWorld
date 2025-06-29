extends CharacterBody2D

const SPEED := 35000.0
const JUMP_FORCE := -200.0
const GRAVITY := 900.0
var camOffset = 150
@onready var sprite = $Sprite2D
var activeMagnetList = []
var magAcc = 5 # how fast u accelerate in magMovement

func _ready() -> void:
	$magManager.connect("magChange", Callable(self, "updateMagMovement")) # connection ...
	
	camOffset = 150
	$camera.offset = Vector2(0,-camOffset)
	$camera.position = position
	
func _physics_process(delta):
	if activeMagnetList == []:
		groundedMovement(delta)
	else: 
		magnetMovement(delta)
	move_and_slide()

func groundedMovement(delta):
	velocity.y += GRAVITY * delta
	var input_direction := 0.0
	if Input.is_action_pressed("left"):
		input_direction -= 1.0
	if Input.is_action_pressed("right"):
		input_direction += 1.0

	velocity.x = input_direction * SPEED * delta
	if input_direction != 0:
		$looks.flip_h = input_direction < 0
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_FORCE
		
func updateMagMovement():
	activeMagnetList = $magManager.movementMags
	if activeMagnetList == []: camOffset = 150
	else: camOffset = -150
	$camera.offset = Vector2(0,-camOffset) # make this smooth at some point
	
	#something like this
	#$camera.offset = $camera.offset.move_toward(Vector2(0,-camOffset), 500 * get_process_delta_time())
	
func magnetMovement(delta):
	var moveTo := get_midpoint(activeMagnetList) # decides point 2 go 2
	var direction := (moveTo - position) # vector generation
	var distance := direction.length() # distance to go
	if distance > 1.0:  # only move if not already at the target
		var speed : float = distance * magAcc # scale this factor to tune how fast you accelerate
		var velocity := direction.normalized() * speed
		position += velocity * delta
	
func get_midpoint(node_list: Array) -> Vector2:
	var sum := Vector2.ZERO
	var count := 0
	for node in node_list:
		if node and node.has_method("get_global_position"):
			sum += node.global_position
			count += 1
	if count == 0:
		return Vector2.ZERO  # or some fallback
	return sum / count
