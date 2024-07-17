extends StaticBody2D

@onready var particles = $Particles
@onready var collision_shape_2d = $CollisionShape2D
@onready var player_detector = $PlayerDetector
@onready var sprite_2d = $Sprite2D
@onready var regen_timer = $RegenTimer

#
#
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass


func explode():
	print("sploded!")
	
	particles.emitting = true
	collision_shape_2d.disabled = true
	sprite_2d.visible = false
	
	regen_timer.start()
	


func _on_regen_timer_timeout():
	collision_shape_2d.disabled = false
	sprite_2d.visible = true
	
	var bodies = player_detector.get_overlapping_bodies()
	print(bodies)
	if bodies:
		bodies[0].i_died()
