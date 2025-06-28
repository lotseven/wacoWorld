extends Node2D
var bulletList
@export var maxBullets = 3
func _ready() -> void:
	Pointer.clickCoords.connect(clickRcv)
	
func clickRcv(coords):
	print("clicked @: ", coords, " (printed from magGun.gd)")
