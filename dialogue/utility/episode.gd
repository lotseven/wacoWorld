extends Node
class_name episode
var completed = false # has this scene already happened?
var isOpener = false # is this the scene that runs when no other scene has to?
var characterCount = 1 # how many characters are involved in this scene? 
var myJSON # variable 4 da json file it reads from... maybe
var lineList = []
var curLine = 0

func _ready():
	"episode intantiated (in class episode)"
	pass

func sendToUI(dialogue, optionList):
	#send dialogue
	#send options
	pass

func rcvFromUI():
	var num
	# code to send the option
	return num

func goToEp(num):
	curLine = num
	
