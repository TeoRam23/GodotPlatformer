extends Node2D

@export var blocks_tall = 17
@export var extra_pixl = 0
@export var vertical_override = 0
@export var pixel_speed = 0.0
@export var gravity_scale = 0.69
@export var max_down_velocity = 300
@export var spawn_delay = 2

var jump_velocity = -323.5
# -142.0 for 1 block
# -323.5 for 5 block
# -601.0 for 17 block
# -460.0 for 10 block

var BUBBL = preload("res://explo/scenes/world-3/ex_lava_bubble.tscn")

var created_bubbles = []

@onready var spawn_timer = $SpawnTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_timer.wait_time = spawn_delay
	spawn_timer.start()
	
	if vertical_override:
		jump_velocity = vertical_override
	else:
		jump_velocity = (-0.000463931+sqrt(-0.000463931**2 - (0.000185132*(0.0007942-(blocks_tall+(extra_pixl*0.0625))))))/(0.000046283*2) *-1
		# kalkulerer velocetey for hvor høyt den skal hoppe i blokker og pixler
	pixel_speed = pixel_speed * 60
	create_bubble()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func create_bubble():
	#print("creating bubble...")
	var new_bubble = BUBBL.instantiate()
	add_child(new_bubble)
	new_bubble.jump_velocity = jump_velocity
	new_bubble.speed = pixel_speed
	new_bubble.gravity_scale = gravity_scale
	new_bubble.max_down_velocity = max_down_velocity
	
	new_bubble.launch_bubble()
	
	created_bubbles.append(new_bubble)
	


func _on_spawn_timer_timeout():
	for bub in created_bubbles:
		if !bub.activated:
			bub.launch_bubble()
			return
	
	create_bubble()
