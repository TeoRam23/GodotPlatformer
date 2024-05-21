extends Node2D

@onready var life_time = $LifeTimeI

var SQAR = preload("res://life/infinite/inf_conway2.tscn")

var pausing = true

@export var width = 20
@export var height = 12
@export var size = 16
@export var set_time = 0.5
@export var alive = false
@export var random = false


signal inf_toggle_life()
signal inf_update_please()
signal inf_lets_carcass()


# Dette må nesten opptimaliseres! hvis jeg gidder fremtidsmeg
func _ready():
	if set_time <= 0.01:
		set_time = 0.15
	life_time.wait_time = set_time
#	place_grid()


func _process(delta):
	if Input.is_action_just_pressed("start"):
		pausing = !pausing
		inf_toggle_life.emit()
		if life_time.time_left:
			life_time.stop()
		else:
			life_time.start()
			
	if pausing:
		if Input.is_action_pressed("LMB"):
			var mouse_position = get_local_mouse_position()
			if mouse_position.x < 0: mouse_position.x -= size
			if mouse_position.y < 0: mouse_position.y -= size
			var pos_x = int(mouse_position.x / size)
			var pos_y = int(mouse_position.y / size)
			print(pos_x, ", ", pos_y)
			place_conway(pos_x, pos_y)
			
			
			



func place_conway(x, y):
	var children = get_children()
	for kid in children:
#		print("COming through")
		if !kid.is_in_group("grp_conways"):
#			print("Lest split up gang")
			continue
		elif kid.position == Vector2(x * size, y * size):
			if !kid.ALIVE:
				kid.change_state()
#			print("WOAH")
			return
	var new_square = SQAR.instantiate()
	
	new_square.position.x = x * size
	new_square.position.y = y * size
	new_square.scale.x = size
	new_square.scale.y = size
	new_square.size = size
	
	new_square.change_state()
	
	add_child(new_square)


#func _draw():
#	var lightness = 0.5
#	for y in height:
#		var points = [Vector2(0, y * size), Vector2(width * size, y * size)]
#		var color = [Color(lightness, lightness, lightness), Color(lightness, lightness, lightness)]
#
#		draw_polyline_colors(points, color, 0.3)
#	for x in width:
#		var points = [Vector2(x * size, 0), Vector2(x * size, height * size)]
#		var color = [Color(lightness, lightness, lightness), Color(lightness, lightness, lightness)]
#
#		draw_polyline_colors(points, color, 0.3)
		
#func everybody_carcass():
#	var children = get_children()
#	for kid in children:
#		if kid.is_in_group("grp_conways"):
#			kid.place_carcass()
#			1 + 1
##			print("shouldve carced by now")
##			print("MA KIDS: ", get_children())


func _on_life_time_i_timeout():
#	print("here we go folks")
	inf_update_please.emit()
#	everybody_carcass()
	inf_lets_carcass.emit()
