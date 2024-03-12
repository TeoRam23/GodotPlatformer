extends Node2D

@onready var life_time = $LifeTime

var SQAR = preload("res://life/scenes/conway.tscn")

var pausing = true

@export var width = 20
@export var height = 12
@export var size = 16
@export var set_time = 0.5
@export var alive = false
@export var random = false


signal toggle_life()
signal update_please()


func _ready():
	if set_time <= 0.01:
		set_time = 0.02
	life_time.wait_time = set_time
	place_grid()


func _process(delta):
	if Input.is_action_just_pressed("start"):
		pausing = !pausing
		toggle_life.emit()
		if life_time.time_left:
			life_time.stop()
		else:
			life_time.start()



func place_grid():
	for y in height:
		for x in width:
			var new_square = SQAR.instantiate()
			
			new_square.position.x = x * size
			new_square.position.y = y * size
			new_square.scale.x = size
			new_square.scale.y = size
			
			var rand_pick = randi_range(0, 2)
			if alive or rand_pick == 1:
				new_square.change_state()
			
			add_child(new_square)


func _draw():
	var lightness = 0.5
	for y in height:
		var points = [Vector2(0, y * size), Vector2(width * size, y * size)]
		var color = [Color(lightness, lightness, lightness), Color(lightness, lightness, lightness)]
		
		draw_polyline_colors(points, color, 0.3)
	for x in width:
		var points = [Vector2(x * size, 0), Vector2(x * size, height * size)]
		var color = [Color(lightness, lightness, lightness), Color(lightness, lightness, lightness)]
		
		draw_polyline_colors(points, color, 0.3)


func _on_life_time_timeout():
	update_please.emit()
