extends StaticBody2D

@onready var frag_timer = $FragTimer
@onready var particles = $StandardParticles
@onready var sprite_real = $SpriteReal

var gonna_free = false
var shaking = false
var zero_next_frame = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if shaking:
		shake()
	
	
	if gonna_free:
		var particle_position = particles.global_position
		remove_child(particles)
		get_parent().add_child(particles)
		particles.global_position = particle_position
		particles.emitting = true
		free()
		


func _on_area_2d_body_entered(body):
	frag_timer.start()
	shaking = true


func _on_frag_timer_timeout():
	#call_deferred("free")
	print("frggled!")
	gonna_free = true

func shake():
	if !sprite_real.position and !zero_next_frame:
		print(sprite_real.position)
		sprite_real.position.x = randi_range(-2, 2)
		sprite_real.position.y = randi_range(-2, 2)
	elif zero_next_frame:
		print(sprite_real.position)
		sprite_real.position = Vector2.ZERO
		zero_next_frame = false
	else:
		print(sprite_real.position)
		sprite_real.position = Vector2.ZERO
		zero_next_frame = true
		
		
	randi_range(-2, 2)

func explode():
	call_deferred("free")
	print("sploded!")
	gonna_free = true
