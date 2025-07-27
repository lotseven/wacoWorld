extends CharacterBody2D
var myVec # the vector in which this projectile shall fly
@export var speed = 5000 # the speed with which this projtile shall fly
var myAngle # the angle at which this projectile shall appear
var player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	rotation_degrees = myAngle

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(myVec * speed * delta)
	if collision:
			SignalBus.emit_signal("createMagnet", collision.get_collider(), global_position, myAngle)
			queue_free()
