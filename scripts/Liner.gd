extends Node2D
var currentPos = global_position

var posArray = []
var colorArray = []


@export var color = Color()
@export var line_width = 5.0
@export var length = 5

var color1
var color2 = [ Color(1, 1, 1), Color(1, 1, 1),  Color(1, 1, 1)]

func _ready():
	color1 = [color, color, color]
	for i in length:
		posArray.append(currentPos - currentPos)
	for i in range(length * 0.5 + 1):
		colorArray += color1 if i % 4 < 2 else color2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_rotation_degrees = 0
	currentPos = global_position
	queue_redraw()
	

func _draw():
	var points = [currentPos - currentPos] + posArray.map(removeCurrent)

	var line_color = [color, Color(1, 1, 1), color, Color(1, 1, 1), color, Color(1, 1, 1), color, Color(1, 1, 1), color, Color(1, 1, 1), color, Color(1, 1, 1), color, Color(1, 1, 1), color, Color(1, 1, 1), color]
	points = points.duplicate()
	points.reverse()
	draw_polyline_colors(points, colorArray, line_width)
	for i in range(posArray.size()-1, -1, -1):
		if i != 0:
			posArray[i] = posArray[i-1]
		else:
			posArray[i] = currentPos

func removeCurrent(value):
	return value - currentPos
