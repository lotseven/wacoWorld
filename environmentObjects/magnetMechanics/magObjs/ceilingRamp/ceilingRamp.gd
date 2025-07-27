extends genPurposeMagnetable


var shouldRotate = true
var vectorFactor = 1
var forceVec = Vector2.ZERO

func _ready():
	super._ready()

func _physics_process(delta): # positions must be updated every frame bcause they change in relation to the moving object every frame
	# so this is counterintuitive but must be done i believe
	if otherPositions != []:
		for pos in otherPositions:
			var toPosVec  = pos - global_position
			var dist = toPosVec.length()
			forceVec += toPosVec.normalized() * vectorFactor
	else: forceVec = Vector2.ZERO
	apply_central_force(forceVec)
