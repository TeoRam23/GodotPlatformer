extends TileMap

@onready var sub_viewport = $SubViewport
#@onready var sub_viewport = $SubViewportContainer/SubViewport
@onready var camera_2d = $Camera2D


#@onready var gloop_holder_node = $SubViewportContainer/SubViewport/GloopHolderNode
@onready var gloop_holder_node = $SubViewport/GloopHolderNode
#@onready var gloop_holder_node = $GloopHolderNode


# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("transfer_children")
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#print("START")
	#print("hold pos: ", gloop_holder_node.position, " and... ", gloop_holder_node.global_position)
	##sub_viewport.world_2d = get_world_2d()
	#for child in gloop_holder_node.get_children():
		#print(child, " my position is ", child.position)
	#print("END")

func transfer_children():
	var children = get_children()
	print("is this printed dude? ", children)
	
	for child in children:
		if child.is_in_group("gloop_hazard"):
			print("found somebody")
			var child_pos = child.global_position
			remove_child(child)
			gloop_holder_node.add_child(child)
			child.global_position = child_pos


func _input(event):
	if event.is_action_pressed("right"):
		camera_2d.position.x += 15
	if event.is_action_pressed("left"):
		camera_2d.position.x -= 15

