extends StaticBody2D

@onready var particles = $Particles
@onready var collision_shape_2d = $CollisionShape2D
@onready var player_detector = $PlayerDetector
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var regen_timer = $RegenTimer


func _ready() -> void:
	var stage = get_tree().current_scene.name
	var world_number = int(stage.split()[0])
	if world_number == 5:
		animated_sprite_2d.visible = false
		animated_sprite_2d = $AnimatedMush2D
		animated_sprite_2d.visible = true
		particles.color = Color(0.635, 0.184, 0.145)

#
#
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass


func explode():
	#print("sploded!")
	
	particles.emitting = true
	collision_shape_2d.disabled = true
	animated_sprite_2d.visible = false
	
	regen_timer.start()
	


func _on_regen_timer_timeout():
	collision_shape_2d.disabled = false
	animated_sprite_2d.visible = true
	animated_sprite_2d.play("default")
	animated_sprite_2d.play_backwards("default")
	
	var bodies = player_detector.get_overlapping_bodies()
	#print(bodies)
	if bodies:
		bodies[0].i_died(false)
	#dette kan gjøres bedre, men det virker så jeg lar den være
