extends Node
var canTalk = false
var curChar 
var isTalking = false
func _ready() -> void:
	SignalBus.connect("updateCharacterTalking", Callable(self, "updateCharacterTalking"))
	
func _process(delta: float) -> void:
	if canTalk and Input.is_action_just_released("jump") and !isTalking:
		isTalking = true
		var ep = determineEpisode(curChar)
		Dialogic.start(ep)
	elif Dialogic.current_timeline == null: isTalking = false


func updateCharacterTalking(b, char):
	canTalk = b
	curChar = char

func determineEpisode(char):
	match char:
		'testCharacterOne': return testCharacterOneEpisode()

func testCharacterOneEpisode():
	return 'testCharacterOne1'
