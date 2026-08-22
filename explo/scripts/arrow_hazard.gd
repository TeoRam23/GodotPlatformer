extends CharacterBody2D

var break_particle: CPUParticles2D
@onready var break_particle_main: CPUParticles2D = $BreakParticle
@onready var break_particle_mush: CPUParticles2D = $BreakParticleMush
@onready var audio_crack_2d: AudioStreamPlayer2D = $AudioCrack2D
var world_number = 1

func _ready() -> void:
	if world_number == 5:
		break_particle = break_particle_mush
	else:
		break_particle = break_particle_main


func _physics_process(delta):
	move_and_slide()
	
	if is_on_wall():
		var part_pos = break_particle.global_position
		remove_child(break_particle)
		get_parent().add_child(break_particle)
		break_particle.global_position = part_pos
		break_particle.emitting = true
		
		SfxDeconflicter.play(audio_crack_2d)
		audio_crack_2d.reparent(get_parent())
		
		queue_free()
