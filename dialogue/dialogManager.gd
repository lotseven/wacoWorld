extends Node
var canTalk = false
var curChar 
var isTalking = false
var p 
func _ready() -> void:
	p = get_tree().get_first_node_in_group('player')
	SignalBus.connect("updateCharacterInteracting", Callable(self, "updateCharacterTalking"))
	
func _process(delta: float) -> void:
	if canTalk and Input.is_action_just_released("jump") and p.is_on_floor() and !isTalking:
		isTalking = true
		var ep = determineEpisode(curChar)
		Dialogic.start(ep)
	elif Dialogic.current_timeline == null: 
		isTalking = false
	p.isTalking = isTalking

func updateCharacterTalking(b, char):
	canTalk = b
	curChar = char

func determineEpisode(char):
	match char:
		'testCharacterOne': return testCharacterOneEpisode()

func testCharacterOneEpisode():
	if !Dialogic.VAR.testCharacterOne.episodeOneDone: return 'testCharacterOne1'
	else: return 'testCharacterOne2'
