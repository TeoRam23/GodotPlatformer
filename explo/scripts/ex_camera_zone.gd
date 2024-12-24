extends Area2D

@onready var collision_shape = $CollisionShape

@export var camera_zone = false

var rd
var lu
var first_rd
var first_lu


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child.name == "CollisionShape2D":
			print("new col!")
		else:
			print("old col prolly")
	
	rd = collision_shape.shape.extents
	print(rd)
	lu = rd * -1
	rd += global_position
	lu += global_position
	
	Events.pls_camera_limit.connect(get_first_limit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func get_first_limit(rd, lu):
	if !first_rd and !first_lu:
		first_rd = rd
		first_lu = lu


func _on_body_entered(body):
	#print("trying...")
	Events.set_camera_limit(rd, lu)


func _on_body_exited(body):
	Events.set_camera_limit(first_rd, first_lu)
