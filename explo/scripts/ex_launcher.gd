extends Node2D

var throw_power = -400
var gravity_scale = 0.5


var PROJ = preload("res://explo/scenes/ex_projectile.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("musL"):
		eject_proj()


func eject_proj():
	var mouse = get_global_mouse_position()
	#var angle = global_position.angle_to_point(mouse)
	var angle = mouse.angle_to_point(global_position)
	angle = (angle * -1) + (PI *0.5)
	
	var new_proj = PROJ.instantiate()
	
	new_proj.position = global_position
	new_proj.angle = angle
	new_proj.throw_power = throw_power
	new_proj.gravity_scale = gravity_scale
	
	get_parent().get_parent().add_child(new_proj)
