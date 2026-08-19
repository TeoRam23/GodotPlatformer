extends Area2D

@onready var collision_shape = $CollisionShape

@export var camera_zone = false

var rd
var lu
var first_rd
var first_lu

var current_rd
var current_lu

var temp_rd
var temp_lu

var body_is_in = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#for child in get_children():
		#if child.name == "CollisionShape2D":
			#print("new col!")
		#else:
			#print("old col prolly")
	
	rd = collision_shape.shape.extents
	#print(rd)
	lu = rd * -1
	rd += global_position
	lu += global_position
	
	Events.pls_camera_limit.connect(listen_for_limit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func listen_for_limit(lis_rd, lis_lu):
	if body_is_in and lis_rd == first_rd and lis_lu == first_lu:
		Events.set_camera_limit(rd, lu)
		
	
	
	if !first_rd and !first_lu:
		first_rd = lis_rd
		first_lu = lis_lu
	else:
		current_rd = lis_rd
		current_lu = lis_lu
	


func _on_body_entered(body):
	#print("trying...")
	body_is_in = true
	Events.set_camera_limit(rd, lu)


func _on_body_exited(body):
	body_is_in = false
	if current_rd == rd and current_lu == lu:
		Events.set_camera_limit(first_rd, first_lu)
	
