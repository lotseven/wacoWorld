extends Node
var episodeRunning
var episodePath = 'res://dialogue/' # will contain the path to the episode 
var episodeNode # node of the episode itself
func _ready() -> void:
	episodeRunning = false
	SignalBus.connect('startEpisode', Callable(self, 'startEpisode'))

func startEpisode(char):
	var newEpisode = determineEpisode(char)
	if newEpisode:
		newEpisode.instantiate()
		self.add_child(newEpisode)
		episodeRunning = true

func determineEpisode(char): # this needs to do what it says
	#"res://dialogue/testCharacter/testEpisodeOne/testEpisodeOne.tscn")
	episodePath += char.to_string()
	print(episodePath)
	return null
