extends Node

@export var numPlayers := 16
@export var bus := "Master"

var available: Array[AudioStreamPlayer] = []
var queue: Array[String] = []

# To manage looped SFX
var loopingPlayers := {}  # Dictionary: name -> AudioStreamPlayer


func _ready():
	for i in numPlayers:
		var player = AudioStreamPlayer.new()
		player.bus = bus
		add_child(player)
		player.finished.connect(onStreamFinished.bind(player))
		available.append(player)


func onStreamFinished(player):
	if player not in loopingPlayers.values():
		available.append(player)


# Basic pooled playback (non-looping SFX)
func playFx(sound_path: String):
	queue.append(sound_path)


func _process(_delta):
	if queue and available:
		var player = available.pop_front()
		player.stream = load(queue.pop_front())
		#player.looping = false
		player.play()


# Start a named looping sound
func startLoopedFx(name: String, sound_path: String):
	if loopingPlayers.has(name):
		return  # Already playing

	var player := AudioStreamPlayer.new()
	player.stream = load(sound_path)
	#player.loop = false
	player.bus = bus
	add_child(player)
	loopingPlayers[name] = player
	player.play()


# Stop a named looping sound
func stopLoopedFx(name: String):
	if loopingPlayers.has(name):
		var player = loopingPlayers.get(name)
		player.stop()
		player.queue_free()
		loopingPlayers.erase(name)
