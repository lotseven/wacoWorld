extends statbodyMagnetable

var tween: Tween
var duration := 0.1

func _ready():
	super._ready()

func _physics_process(delta):
	if otherPositions.size() > 0:
		var raw_angle = findAngle()
		var angle_diff = wrapf(raw_angle - rotation, -PI, PI)
		var target_angle = rotation + angle_diff

		if tween and tween.is_running():
			tween.kill() # resets the tween
			
		tween = create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "rotation", target_angle, duration)
		
func findAngle() -> float:
	var sum_vector := Vector2.ZERO
	for pos in otherPositions:
		sum_vector += (pos - global_position).normalized()
	return sum_vector.angle() if sum_vector.length() > 0 else 0.0
