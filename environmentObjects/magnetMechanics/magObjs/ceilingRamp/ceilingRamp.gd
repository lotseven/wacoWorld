extends rigbodyMagnetable

var shouldRotate = true
var vectorFactor = 12
var forceVec = Vector2.ZERO
var snapDist = 100

func _ready():
	super._ready()

func _physics_process(delta): # positions must be updated every frame bcause they change in relation to the moving object every frame
	#so this is counterintuitive but must be done i believe
	if otherPositions != []:
		for pos in otherPositions:
			var toPosVec  = pos - global_position
			var dist = toPosVec.length()
			forceVec += toPosVec.normalized() * vectorFactor
	else: forceVec = Vector2.ZERO
	apply_central_force(forceVec)
