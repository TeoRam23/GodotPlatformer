extends StaticBody2D

@onready var launch_timer = $LaunchTimer
@onready var shoop_particle_1: CPUParticles2D = $Particles/ShoopParticle1
@onready var shoop_particle_2: CPUParticles2D = $Particles/ShoopParticle2
@onready var shoop_particle_3: CPUParticles2D = $Particles/ShoopParticle3
@onready var shoop_particle_4: CPUParticles2D = $Particles/ShoopParticle4

const ARROW_HAZARD = preload("res://explo/hazards/arrow_hazard.tscn")
@export var arrow_speed = -180.0
@export var launch_seconds = 1.0
var world_number = 1

@export var launch_on_start = true

var picked_particle = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	var stage = get_tree().current_scene.name
	world_number = int(stage.split()[0])
	if launch_on_start:
		launch_arrow()
	launch_timer.wait_time = launch_seconds
	launch_timer.start()
	
	
	#print("YEP ", launch_seconds)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_launch_timer_timeout():
	launch_arrow()

func launch_arrow():
	var new_arrow = ARROW_HAZARD.instantiate()
	new_arrow.world_number = world_number
	new_arrow.velocity = Vector2.RIGHT.rotated(rotation) * arrow_speed
	
	if picked_particle == 1:
		shoop_particle_1.emitting = true
		picked_particle += 1
	elif picked_particle == 2:
		shoop_particle_2.emitting = true
		picked_particle += 1
	elif picked_particle == 3:
		shoop_particle_3.emitting = true
		picked_particle += 1
	elif picked_particle == 4:
		shoop_particle_4.emitting = true
		picked_particle = 1
		
	
	add_child(new_arrow)
