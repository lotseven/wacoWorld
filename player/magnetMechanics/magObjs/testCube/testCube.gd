extends genPurposeMagnetable

var forceVec : Vector2 # forces 2 be felt every frame
var forceM = 700 * 10**6 # force multiplier
var snapDist = 90
var maxSpeed = 10000

func _ready():
	super._ready()
	#SignalBus.connect('groupingHasChanged',Callable(self, 'updateOtherPositions'))


func _physics_process(delta: float) -> void:
	forceVec = Vector2.ZERO
	if otherPositions!=[]:
		for pos in otherPositions:
			var toPos  = pos - global_position
			var dist = toPos.length()
			if dist <= snapDist: # was hoping this would snap
				forceVec = Vector2.ZERO
			elif dist > 0.01: 
				var strength = forceM / dist**2
				forceVec += toPos.normalized() * strength
				forceVec[0] = clamp(forceVec[0], -maxSpeed, maxSpeed)
				forceVec[1] = clamp(forceVec[1], -maxSpeed, maxSpeed)
				print(forceVec)
		apply_central_force(forceVec)
