extends StaticBody2D

@onready var launch_timer = $LaunchTimer
@onready var wait_timer: Timer = $WaitTimer
@onready var shoop_particle_1: CPUParticles2D = $Particles/ShoopParticle1
@onready var shoop_particle_2: CPUParticles2D = $Particles/ShoopParticle2
@onready var shoop_particle_3: CPUParticles2D = $Particles/ShoopParticle3
@onready var shoop_particle_4: CPUParticles2D = $Particles/ShoopParticle4
@onready var audio_launch: AudioStreamPlayer2D = $AudioLaunch

const ARROW_HAZARD = preload("res://explo/hazards/arrow_hazard.tscn")
# arrow speed var -180, men ble endret til -240 for å matche liknende spill
@export var arrow_speed = -240.0
@export var launch_seconds = 1.0
@export var wait_seconds = 0.0
var world_number = 1

@export var launch_on_start = true

var picked_particle = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	var stage = get_tree().current_scene.name
	world_number = int(stage.split()[0])
	if world_number == 5:
		material.set("shader_parameter/parent_id", world_number)
	
	if launch_on_start:
		launch_arrow()
	launch_timer.wait_time = launch_seconds
		
	if wait_seconds > 0:
		wait_timer.wait_time = wait_seconds
		wait_timer.start()
	else:
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
	
	#audio_launch.play()
	SfxDeconflicter.play(audio_launch)


func _on_wait_timer_timeout() -> void:
	launch_arrow()
	launch_timer.start()
