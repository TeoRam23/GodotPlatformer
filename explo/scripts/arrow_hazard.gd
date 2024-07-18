extends CharacterBody2D

@onready var break_particle = $BreakParticle

func _physics_process(delta):
	move_and_slide()
	
	if is_on_wall():
		var part_pos = break_particle.global_position
		remove_child(break_particle)
		get_parent().add_child(break_particle)
		break_particle.emitting = true
		break_particle.global_position = part_pos
		queue_free()
