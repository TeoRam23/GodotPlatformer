extends StaticBody2D

@onready var standard_sprite = $Sprite2D

@onready var particles = $Particles
@onready var audio_crack_2d: AudioStreamPlayer2D = $AudioCrack2D

var gonna_free = false

@export var type_id = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	# dette brukes for å endre farge på andre blocker
	if type_id == 1:
		standard_sprite.visible = false
		particles.color = Color(0.153, 0.463, 0.459, 1.0)
	if type_id == 2:
		standard_sprite.visible = false
		particles.color = Color(0.259, 0.439, 0.882, 1.0)
	if type_id == 3:
		standard_sprite.visible = false
		particles.color = Color(0.753, 0.733, 0.675)
		
	#pass # Replace with function body.
#
#
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if gonna_free:
		if type_id:
			var particle_position = particles.global_position
			remove_child(particles)
			get_parent().get_parent().add_child(particles)
			particles.global_position = particle_position
			particles.emitting = true
			
			audio_crack_2d.pitch_scale = randf_range(0.9,1.1)
			SfxDeconflicter.play(audio_crack_2d)
			audio_crack_2d.reparent(get_parent().get_parent())
			
			get_parent().free()
		else:
			var particle_position = particles.global_position
			remove_child(particles)
			get_parent().add_child(particles)
			particles.global_position = particle_position
			particles.emitting = true
			
			audio_crack_2d.pitch_scale = randf_range(0.9,1.1)
			SfxDeconflicter.play(audio_crack_2d)
			audio_crack_2d.reparent(get_parent())
			
			free()


func explode():
	call_deferred("free")
	#print("sploded!")
	gonna_free = true
