extends Node2D

@export var blocks_tall = 17
@export var extra_pixl = 0
@export var vertical_override = 0.0
@export var pixel_speed = 0.0
@export var gravity_scale = 0.8
# tidligere gravity scale er 0.69, 0.8 er bedre
@export var max_down_velocity = 300
@export var spawn_delay = 2.0
@export var starts_in_lava = false
@export var show_particles = true
@export var float_on_spawn = true

var jump_velocity = 0

#vvvv gammelt for 0.69 gravity vvvv
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
	
	# hvis jeg vil ha full kontroll over velocity
	if vertical_override:
		jump_velocity = vertical_override
	else:
		# brukte å kalkulere velocetey for hvor høyt den skal hoppe i blokker og pixler med 0.69 i gravitasjon
		#jump_velocity = (-0.000463931+sqrt(-0.000463931**2 - (0.000185132*(0.0007942-(blocks_tall+(extra_pixl*0.0625))))))/(0.000046283*2) *-1
		
		if blocks_tall != 0 or extra_pixl != 0:
			#print("ooh.. denne kjører......")
			# kalkulerer velocetey for hvor høyt den skal hoppe i blokker og pixler med 0.8 i gravitasjon og stall i lufta
			jump_velocity = 7.62494 - (149.06665*sqrt(0.00261421 + (1.13235 * (blocks_tall+(extra_pixl*0.0625)))))
			# justerte jump velocity for 0.8 i gravity, som jeg fant var bedre. vet ikke om jeg kan lage dette dynamisk for all gravitasjon?
		#if gravity_scale == 0.8:
			#jump_velocity = jump_velocity * 1.076664780762374
	#print("Velocetey: ",jump_velocity)
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
	new_bubble.lava_can_kill = !starts_in_lava
	new_bubble.show_particles = show_particles
	new_bubble.float_on_spawn = float_on_spawn
	#print("Launcher: ",new_bubble.show_particles)
	
	# den trenger å launches her, gjør man edt i ready() vil den ikke ha variablene over!
	new_bubble.launch_bubble()
	
	created_bubbles.append(new_bubble)
	


func _on_spawn_timer_timeout():
	for bub in created_bubbles:
		if !bub.activated:
			bub.launch_bubble()
			return
	
	create_bubble()
