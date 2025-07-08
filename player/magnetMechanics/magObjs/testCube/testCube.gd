extends genPurposeMagnetable

var otherPositions = []
var forceVec : Vector2 # forces 2 be felt every frame
var forceM = 700 * 10**6 # force multiplier
var snapDist = 45
func _ready():
	super._ready()
	SignalBus.connect('groupingHasChanged',Callable(self, 'updateOtherPositions'))

func updateOtherPositions():
	if groups != []: # if it got da magnet
		otherPositions = [] # reset and rebuild
		for i in groups:
			if MagnetContainer.groupedMagList != {}:
				for k in MagnetContainer.groupedMagList[i]:
					if !myMags.has(k):
						otherPositions.append(k.global_position) # ok its rebuilt :)
			else: print("Error in genPurposeMagnetable: MagnetContainer.groupedMagList is empty")

func _physics_process(delta: float) -> void:
	forceVec = Vector2.ZERO
	for pos in otherPositions:
		var toPos  = pos - global_position
		var dist = toPos.length()
		
		if dist <= snapDist:
			linear_velocity = Vector2.ZERO
			forceVec = Vector2.ZERO
			
		elif dist > 0.01: 
			var strength = forceM / dist**2
			forceVec += toPos.normalized() * strength
			if dist<=snapDist:
				forceVec = Vector2.ZERO
				linear_velocity = Vector2.ZERO
				
	if forceVec != Vector2.ZERO:		
		apply_central_force(forceVec)
