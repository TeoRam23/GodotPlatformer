extends CharacterBody2D

var throw_power = -300
var angle = 0
var gravity_scale = 1

var first_frame = true

var has_launched = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var my_root

@onready var projectile_shape = $ProjectileShape
@onready var explosion_body = $ExplosionBody
@onready var explosion_area = $ExplosionBody/explosion_area
@onready var timer = $Timer
@onready var animated_sprite = $AnimatedSprite2D

const EX_PNG = preload("res://explo/scenes/ex_png.tscn")

func _ready():
	my_root = get_tree().get_root()
	#var cuisine = cos(angle)
	#var sine = sin(angle)
	#velocity.x = (0 * cuisine + throw_power * sine)
	#velocity.y = (0 * sine + throw_power * cuisine)
	
	
	#move_and_slide()


func _physics_process(delta):
	#print(timer.time_left)
	
	#if is_on_wall():
		#explode_pls()

	
	# Add the gravity.
	if has_launched:
		apply_gravity(delta)
		move_and_slide()
		apply_second_gravity(delta)
		
	else:
		move_and_slide()
	
	if is_on_wall():
		explode_pls()
				
				#if !first_frame:
				#if !illsplode:
				#explode_pls()
			#illsplode = true
	
		
		
		#animated_sprite.visible = false
		#position = get_last_slide_collision().get_position()
		#velocity = Vector2(0, 0)
	
	first_frame = false
	
	


func apply_gravity(delta):
	#if not is_on_floor() and velocity.y >= throw_power:
		#velocity.y += gravity * gravity_scale * delta
		
	velocity.y += gravity * gravity_scale * delta
	if velocity.y > 350:
		velocity.y = 350

func apply_second_gravity(delta):
	explosion_body.position = Vector2(0, 0)
	explosion_body.velocity = velocity
	explosion_body.velocity.y += gravity * gravity_scale * delta
	if explosion_body.velocity.y > 350:
		explosion_body.velocity.y = 350
	#newvelocity = Vector2(50, 50)
	#newvelocity = newvelocity * delta
	#explosion_area.position = newvelocity
	explosion_body.move_and_slide()

func launch():
	has_launched = true
	if is_on_wall():
		position = get_last_slide_collision().get_position()
		explode_pls()
		return
	var cuisine = cos(angle)
	var sine = sin(angle)
	velocity.x = (0 * cuisine + throw_power * sine)
	velocity.y = (0 * sine + throw_power * cuisine)
	global_rotation = 0
	visible = true

#func _on_level_check_body_entered(body):
	#if explosion_area.get_overlapping_bodies():
		#var bodies = explosion_area.get_overlapping_bodies()
		#
		## checks if body can explode or gets pushed
		#for bod in bodies:
			#if bod.has_method("explode"):
				#bod.explode()
	#queue_free()


func explode_pls():
	if !has_launched:
		return
	if explosion_area.get_overlapping_bodies():
		var bodies = explosion_area.get_overlapping_bodies()
		
		# checks if body can explode or gets pushed
		print("Bod: ", bodies)
		for bod in bodies:
			if bod.has_method("explode"):
				bod.explode()
			elif bod.has_method("launch_me"):
				var angle = get_launch_angle(bod)
				bod.launch_me(angle, throw_power)
	var explod = EX_PNG.instantiate()
	explod.position = explosion_area.global_position
	my_root.add_child(explod)
	#illsplode = true
	queue_free()

func get_launch_angle(bod):
	var other_pos = bod.global_position
	var angle = other_pos.angle_to_point(global_position)
	angle = (angle * -1) + (PI *0.5)
	return angle


func _on_timer_timeout():
	print("1!")
