extends Node2D

@onready var life_time = $Timer

@export var start_rows = 10
@export var start_cols = 10
@export var size = 16.0
@export var set_time = 0.5
@export var alive = false
@export var random = false
@export var line = 3.0

var start_grid

func _ready():
	start_grid = create_array(start_rows,start_cols, true)
	if set_time <= 0.01:
		set_time = 0.017
	life_time.wait_time = set_time

func _process(delta):
	if Input.is_action_just_pressed("start"):
		if life_time.time_left:
			life_time.stop()
		else:
			life_time.start()
	
	place_conways()
	
#	if Input.is_action_just_pressed("LMB"):
#		var tile : Vector2 = local_to_map(get_global_mouse_position())
#		print(tile)
#		set_cell(0, tile)


func update_grid(grid, rows, cols):
	var new_grid = zeros_like(grid)
	for i in rows:
		for o in cols:
			var live_neighbors = count_live_neighbors(grid, i, o, rows, cols)
			if grid[i][o] == 1:
				new_grid[i][o] = 1 if live_neighbors in [2, 3] else 0
			else:
				new_grid[i][o] = 1 if live_neighbors == 3 else 0
	return new_grid
	

func place_conways():
	if Input.is_action_pressed("LMB") or Input.is_action_pressed("RMB"):
		var mouse_position = get_global_mouse_position()
		for i in start_rows:
			for o in start_cols:
				var rect = Rect2(o * size, i * size, size, size)
				if rect.has_point(mouse_position):
					start_grid[i][o] = 1 if Input.is_action_pressed("LMB") else 0
					queue_redraw()


func create_array(number1, number2, isrows):
	var new_array = []
	for i in number1:
		if isrows:
			new_array.append(create_array(number2, 0, false))
		else:
			if alive:
				new_array.append(1)
			elif random:
				new_array.append(randi_range(0,1))
			else:
				new_array.append(0)
	return new_array

func zeros_like(array):
	var new_array = []
	for i in array:
		if i is Array:
			new_array.append(zeros_like(i))
		else:
			new_array.append(0)
	return new_array

func count_live_neighbors(agrid, i, o, arows, acols):
	var liver_neighbors = 0
#	for x in range(max(0, i-1), min(arows, i+2)):
#		for y in range(max(0, o-1), min(acols, o+2)):
#			if x != i or y != o:
#				liver_neighbors += agrid[x][y]

	for x in range(i - 1, i + 2):
		for y in range(o - 1, o + 2):
			var row = (x + arows) % arows
			var col = (y + acols) % acols
			if row != i or col != o:
				liver_neighbors += agrid[row][col]
	return liver_neighbors


func _draw():
	for i in range(start_rows):
		for o in range(start_cols):
			if start_grid[i][o] == 1:
				draw_rect(Rect2(o * size, i * size, size, size), Color(0.604, 0.871, 0.557))
			else:
				draw_rect(Rect2(o * size, i * size, size, size), Color(0.87, 0.87, 0.87))
				
	var lightness = 0.5
	for y in start_rows:
		var points = [Vector2(0, y * size), Vector2(start_cols * size, y * size)]
		var color = [Color(lightness, lightness, lightness), Color(lightness, lightness, lightness)]
		
		draw_polyline_colors(points, color, line * 0.1)
	for x in start_cols:
		var points = [Vector2(x * size, 0), Vector2(x * size, start_rows * size)]
		var color = [Color(lightness, lightness, lightness), Color(lightness, lightness, lightness)]
		
		draw_polyline_colors(points, color, line * 0.1)


func _on_timer_timeout():
	start_grid = update_grid(start_grid, start_rows, start_cols)
	queue_redraw()
