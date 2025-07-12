extends Node

var currentLine
@export var selectionLine : PackedScene

func addPoint(point):
	if !currentLine:
		currentLine = selectionLine.instantiate()
		self.add_child(currentLine)
		currentLine.add_point(point)
	else:
		currentLine.add_point(point)

func endLine():
	if currentLine: currentLine.queue_free()

func recallAll():
	for child in get_children():
		child.queue_free()
