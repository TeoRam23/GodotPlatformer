extends Node2D

#var throw_power = -490
#var gravity_scale = 0.7
#var throw_power = -400
#var gravity_scale = 0.52
var throw_power = -450
var gravity_scale = 0.67
#var gravity_scale = 0.0
#var throw_power = -350
#var gravity_scale = 0.4
@onready var proj_timer = $ProjTimer
@onready var spawn_anchor = $SpawnAnchor
@onready var spawn_point = $SpawnAnchor/SpawnPoint
@onready var polygon_arrow = $PolygonArrow

var PROJ = preload("res://explo/scenes/ex_projectile.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_spawn_point()
	if Input.is_action_just_pressed("musL"):
		eject_proj()


func eject_proj():
	var number = get_tree().get_nodes_in_group("projectile")
	if number.size() > 0 and proj_timer.time_left > 0:
		return
	
	var mouse = get_global_mouse_position()
	#var angle = global_position.angle_to_point(mouse)
	var angle = mouse.angle_to_point(global_position)
	angle = (angle * -1) + (PI *0.5)
	
	var new_proj = PROJ.instantiate()
	
	new_proj.position = spawn_point.global_position
	new_proj.angle = angle
	new_proj.throw_power = throw_power
	new_proj.gravity_scale = gravity_scale
	
	get_parent().get_parent().add_child(new_proj)
	proj_timer.start()



func move_spawn_point():
	var mouse = get_global_mouse_position()
	#var angle = global_position.angle_to_point(mouse)
	var angle = mouse.angle_to_point(global_position)
	print(angle)
	
	spawn_anchor.rotation = angle# + PI * 0.5
	spawn_anchor.position.y = 0
	spawn_anchor.position.y = (spawn_point.global_position.y - spawn_anchor.global_position.y) * 0.57
	
	polygon_arrow.rotation = angle# + PI * 0.5
	#polygon_arrow.position.y -= abs(spawn_anchor.position.y)
	#print("poly: ",polygon_arrow.position.y, "anch: ", spawn_anchor.position.y)
	
	
	
