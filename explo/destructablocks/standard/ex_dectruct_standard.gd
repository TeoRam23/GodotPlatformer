extends StaticBody2D

@onready var particles = $Particles

var gonna_free = false
# Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.
#
#
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if gonna_free:
		var particle_position = particles.global_position
		remove_child(particles)
		get_parent().add_child(particles)
		particles.global_position = particle_position
		particles.emitting = true
		free()


func explode():
	call_deferred("free")
	print("sploded!")
	gonna_free = true
