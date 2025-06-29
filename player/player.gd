extends CharacterBody2D

const SPEED := 35000.0
const JUMP_FORCE := -200.0
const GRAVITY := 900.0
var camOffset = 150
var camOffSaved = 150
@onready var sprite = $Sprite2D
@onready var groundHitbox = $groundHitbox
@onready var magHitbox = $magHitbox
var activeMagnetList
var magAcc = 3
var maxMags = 3

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
	if Input.is_action_pressed("left"):
		input_direction -= 1.0
	if Input.is_action_pressed("right"):
		input_direction += 1.0

	velocity.x = input_direction * SPEED * delta
	move_and_slide()

	if input_direction != 0:
		$looks.flip_h = input_direction < 0
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_FORCE

func updateMagMovement():
	activeMagnetList = $magManager.movementMags

func magnetMovement(delta):
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

# Toggle hitboxes
func switch_to_grounded():
	groundHitbox.disabled = false
	magHitbox.disabled = true

func switch_to_magnet():
	groundHitbox.disabled = true
	magHitbox.disabled = false
