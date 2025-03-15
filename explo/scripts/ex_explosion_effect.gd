extends Node2D

@onready var particles = $Particles
@onready var explosion_animation = $ExplosionAnimation
@onready var explosion_particles = $ExplosionParticles

# Called when the node enters the scene tree for the first time.
func _ready():
	explosion_particles.emitting = true
	#particles.emitting = true
	#pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass


func _on_particles_finished():
	queue_free()


func _on_explosion_animation_animation_finished():
	explosion_animation.visible = false


func _on_explosion_particles_finished():
	queue_free()
