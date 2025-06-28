extends CharacterBody2D

const SPEED := 350.0
const JUMP_FORCE := -200.0
const GRAVITY := 900.0
@export var camOffset = 150
@onready var sprite = $Sprite2D

func _ready() -> void:
	$camera.offset = Vector2(0,-camOffset)
	
func _physics_process(delta):
	velocity.y += GRAVITY * delta
	var input_direction := 0.0
	if Input.is_action_pressed("left"):
		input_direction -= 1.0
	if Input.is_action_pressed("right"):
		input_direction += 1.0

	velocity.x = input_direction * SPEED

	if input_direction != 0:
		$looks.flip_h = input_direction < 0
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_FORCE

	move_and_slide()
