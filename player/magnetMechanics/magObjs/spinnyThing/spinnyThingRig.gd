extends genPurposeMagnetable

var center := Vector2.ZERO
var radius := 250
var angular_speed := 1.0 # radians per second

func _ready():
	super._ready()
	center = global_position 

	var start_offset = Vector2(radius, 0)
	global_position = center + start_offset

	var tangential_velocity = Vector2(0, 1).rotated(0) * angular_speed * radius
	linear_velocity = tangential_velocity
	
func _physics_process(delta: float) -> void:
	var to_center = center - global_position
	var distance = to_center.length()

	var force_dir = to_center.normalized()
	var force_mag = mass * pow(angular_speed, 2) * radius

	apply_central_force(force_dir * force_mag)
