extends StaticBody2D
@export var switchTo : PackedScene
# STATIC BODY DETECTION SWITCHER

func magAtch(pos, ang):
	print("I have a magnet attached to me at ", pos, " printed from staticBodyDetection.gd")
	var magObj = switchTo.instantiate()
	magObj.global_position = global_position
	magObj.global_rotation = global_rotation
	magObj.global_scale = global_scale
	magObj.magPos = pos
	magObj.magAng = ang
	magObj.atchPos = global_position
	get_parent().add_child(magObj)
	queue_free()
