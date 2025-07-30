extends statbodyMagnetable

var tween: Tween
var duration := 0.1

func _ready():
	super._ready()

func _physics_process(delta):
	if otherPositions.size() > 0:
		var rawAngle = findAngle()
		var angleDiff = wrapf(rawAngle - rotation, -PI, PI)
		var targetAngle = rotation + angleDiff
		var degAngle = rad_to_deg(targetAngle)

		if tween and tween.is_running():
			tween.kill() # resets the tween
			
		tween = create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "rotation", targetAngle, duration)

func findAngle() -> float:
	var sum_vector := Vector2.ZERO
	for pos in otherPositions:
		sum_vector += (pos - global_position).normalized()
	return sum_vector.angle() if sum_vector.length() > 0 else 0.0
