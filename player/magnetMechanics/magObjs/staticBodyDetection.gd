extends StaticBody2D
class_name staticBodyDetection
@export var switchTo : PackedScene
# STATIC BODY DETECTION SWITCHER
func magAtch(pos, angle):
	var replaceObj = switchTo.instantiate()
	replaceObj.global_position = global_position
	replaceObj.global_rotation = global_rotation
	replaceObj.global_scale = global_scale
	
	replaceObj.magPos = pos
	replaceObj.atchPos = global_position
	replaceObj.magAngle = angle
	
	get_parent().add_child(replaceObj)
	queue_free()
