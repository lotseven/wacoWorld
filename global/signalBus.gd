extends Node

signal updateAimArrowVisibility(visible) # from magGun to ui
signal createMagnet(object, position, angle) # from magnetProjectile to magGun
signal magnetButtonClick(magnet) # from magnet to magManager
