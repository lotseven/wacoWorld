extends StaticBody2D
@export var switchTo : PackedScene

# STATIC BODY DETECTION SWITCHER
func magAtch(pos):
	print("I have a magnet attached to me at ", pos, " printed from staticBodyDetection.gd")
	switch(switchTo, pos)

func switch(node, pos):
	pass
	var magObj = switchTo.instantiate()
	magObj.global_position = global_position
	magObj.global_rotation = global_rotation
	magObj.global_scale = global_scale
	magObj.magPos = pos
	magObj.atchPos = global_position
	get_parent().add_child(magObj)
	queue_free()
