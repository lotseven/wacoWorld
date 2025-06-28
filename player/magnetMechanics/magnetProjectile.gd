extends Node2D
var myVec # the vector in which this projectile shall fly
@export var speed = 40 # the speed with which this projtile shall fly
var myAngle # the angle at which this projectile shall appear

func _ready() -> void:
	rotation_degrees = myAngle
