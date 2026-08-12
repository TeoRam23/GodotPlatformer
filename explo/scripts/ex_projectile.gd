extends CharacterBody2D

@export var throw_power = -440
@export var gravity_scale = 0.67
@export var launch_power = -410

@export var low_gravity = false
@export var low_gravity_scale = 0.445
@export var low_gravity_fall_speed = 295.7

var angle = 0
var the_launcher
var the_spawner

var first_frame = false

var has_launched = false
var is_in_a_wall = false
var just_launched = false
var do_explosion = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var my_root
var mouse_tracker

var we_are_killed = false

@onready var projectile_shape = $ProjectileShape
@onready var explosion_body = $ExplosionBody
@onready var explosion_area = $ExplosionBody/explosion_area
@onready var timer = $Timer
@onready var animated_sprite = $AnimatedSprite2D
@onready var particle_holder = $ParticleHolder
@onready var gone_timer = $GoneTimer
@onready var area_detection = $AreaDetection
@onready var audio_explode_2d: AudioStreamPlayer2D = $AudioExplode2D
@onready var audio_killed_2d: AudioStreamPlayer2D = $AudioKilled2D

const EX_PNG = preload("res://explo/scenes/ex_png.tscn")

const EX_EXPLOSION = preload("res://explo/scenes/ex_explosion_effect.tscn")
signal projectile_hit_the_ground

func _ready():
	my_root = get_tree().get_root()
	
	Events.pls_low_gravity.connect(lower_gravity)
	#var cuisine = cos(angle)
	#var sine = sin(angle)
	#velocity.x = (0 * cuisine + throw_power * sine)
	#velocity.y = (0 * sine + throw_power * cuisine)
	
	
	#move_and_slide()
#func _process(delta):
	#if !has_launched:
		#move_and_slide()
		#apply_second_gravity(delta, true)

func _physics_process(delta):
	if !has_launched:
		velocity.y = 0
	#print(timer.time_left)
	#if is_on_wall():
		#explode_pls()
	if do_explosion:
		apply_second_gravity(delta, true)
		explode_pls()
		return
	elif first_frame:
		return
		
		#return

	
	# Add the gravity.
	if has_launched and !is_in_a_wall and not just_launched:
		#print("has lunch")
		apply_gravity(delta)
		move_and_slide()
		#if !is_on_wall():
		#apply_second_gravity(delta, false)
		apply_second_gravity(delta, false)
		
		#print("mine: ", global_position, " bod: ", explosion_body.global_position)
		#else: explosion_body.position = Vector2(0,0)
		
	elif not just_launched and is_in_a_wall:
		#print("no lunch")
		#explosion_body.position = Vector2(0, 0)
		move_and_slide()
		#if is_on_wall():
			#var wall_angle = Vector2.RIGHT.rotated(get_angle_to(the_launcher.global_position))
			#print(wall_angle)
			
			#print("WE WALL EY: ", get_wall_normal())
		apply_second_gravity(delta, true)
		
		
		# jeg fjernet dette, men husker ikke hvorfor det var der... hvis problemer, skjekk dette
		#if not is_in_a_wall:
			#explosion_body.position = Vector2(0, 0)
			
	
	elif just_launched:
		apply_second_gravity(delta, true)
	else:
		#print("this is the one moving")
		move_and_slide()
		explosion_body.move_and_slide()
		explosion_body.position = Vector2(0, 0)
		
		
	if is_on_wall() and not is_queued_for_deletion():
		#print("I did this from the process!")
		explode_pls()
	
				#if !first_frame:
				#if !illsplode:
				#explode_pls()
			#illsplode = true
	
		
		
		#animated_sprite.visible = false
		#position = get_last_slide_collision().get_position()
		#velocity = Vector2(0, 0)
	
	first_frame = false
	just_launched = false
	
	
	


func apply_gravity(delta):
	#if not is_on_floor() and velocity.y >= throw_power:
		#velocity.y += gravity * gravity_scale * delta
	
	if low_gravity:
		velocity.y += gravity * low_gravity_scale * gravity_scale * delta
		if velocity.y > low_gravity_fall_speed:
			velocity.y = low_gravity_fall_speed
	else:
		velocity.y += gravity * gravity_scale * delta
		if velocity.y > 350:
			velocity.y = 350

func apply_second_gravity(delta, do_my_own):
	explosion_body.position = Vector2(0, 0)
	if do_my_own:
		if is_on_wall():
			#print("I wall now")
			global_position = the_spawner.get_parent().global_position
			#print("Lunsj: ",the_spawner.get_parent().global_position, " Bod: ", global_position, " Mus: ", get_global_mouse_position())
			move_and_slide()
			is_in_a_wall = true
		else: is_in_a_wall = false
		
		var mouse = Vector2.ZERO
		if mouse_tracker:
			mouse = mouse_tracker.global_position
		else:
			mouse = get_global_mouse_position()
			
		angle = mouse.angle_to_point(the_launcher.global_position)
		#print("Throw: ", throw_power, " Grav: ", gravity_scale, " Angle: ", angle)
		#if !is_on_wall():
		explosion_body.velocity.x = throw_power * cos(angle)
		explosion_body.velocity.y = throw_power * sin(angle)
			##explosion_body.position = Vector2(0, 0)
		#else:
			#explosion_body.velocity = Vector2(0, 0)
			#explosion_body.position = Vector2(0, 0)
	else:
		explosion_body.velocity = velocity
	if low_gravity:
		explosion_body.velocity.y += gravity * low_gravity_scale * gravity_scale * delta
		if explosion_body.velocity.y > low_gravity_fall_speed:
			explosion_body.velocity.y = low_gravity_fall_speed
	else:
		explosion_body.velocity.y += gravity * gravity_scale * delta
		if explosion_body.velocity.y > 350:
			explosion_body.velocity.y = 350
	
	#if the_launcher.get_parent().velocity:
		#explosion_body.velocity += the_launcher.get_parent().velocity
	#newvelocity = Vector2(50, 50)
	#newvelocity = newvelocity * delta
	#explosion_area.position = newvelocity
	explosion_body.move_and_slide()
	
	#if has_launched:
	if explosion_body.is_on_wall():
		#print("IIII Wallin'", explosion_body.get_last_slide_collision().get_position())
		explosion_body.global_position = explosion_body.get_last_slide_collision().get_position()

	if is_on_wall():
		#print("We wallin'", get_last_slide_collision().get_position())
		explosion_body.global_position = get_last_slide_collision().get_position()
	
	

func launch():
	#process_priority = -1
	#process_physics_priority = -1
	has_launched = true
	just_launched = true
	#print("*lunches*")
	
	
	
	
	if explosion_body.is_on_wall() or area_detection.get_overlapping_areas():
		#print("*explodes* ", explosion_body.global_position)
		do_explosion = true
		#position = get_last_slide_collision().get_position()
		return
	#var cuisine = cos(angle)
	#var sine = sin(angle)
	#velocity.x = (0 * cuisine + throw_power * sine)
	#velocity.y = (0 * sine + throw_power * cuisine)
	
	#angle = (angle * -1) + (PI *0.5)
	velocity.x = throw_power * cos(angle)
	velocity.y = throw_power * sin(angle)
	
	global_rotation = 0
	visible = true
	
	timer.start()
	gone_timer.start()

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
	Events.projectile_hit()
	if explosion_area.get_overlapping_bodies():
		var bodies = explosion_area.get_overlapping_bodies()
		bodies += explosion_area.get_overlapping_areas()
		
		# checks if body can explode or gets pushed
		#print("Bod: ", bodies)
		for bod in bodies:
			if bod.has_method("explode"):
				#print("expoddr")
				bod.explode()
			elif bod.has_method("launch_me"):
				var angle = get_launch_angle(bod)
				#print(rad_to_deg(angle))
				bod.launch_me(angle, launch_power)
	var explod = EX_EXPLOSION.instantiate()
	explod.position = explosion_area.global_position
	#print("area: ",explosion_area.global_position, ", bod: ", explosion_body.global_position)
	#print("Mus: ", get_global_mouse_position())
	my_root.add_child(explod)
	
	#audio_explode.pitch_scale = randf_range(1,1.3)
	#audio_explode.playing = true
	#audio_explode.reparent(get_parent())
	
	audio_explode_2d.pitch_scale = randf_range(1,1.3)
	audio_explode_2d.playing = true
	audio_explode_2d.reparent(get_parent())
	
	remove_me(false)
	first_frame = true
	
func remove_me(kill_sound: bool):
		#illsplode = true
	if kill_sound:
		audio_killed_2d.pitch_scale = randf_range(0.9,1.1)
		audio_killed_2d.playing = true
		audio_killed_2d.reparent(get_parent())
		
	if particle_holder.get_parent() == self:
		remove_child(particle_holder)
		get_parent().add_child(particle_holder)
		particle_holder.un_emit()
		# jeg husker ikke hvorfor queue free er inni denne if-en, men ¯\_(ツ)_/¯
		queue_free()
	


func get_launch_angle(bod):
	var other_pos = bod.global_position
	other_pos.y -= 3 # for å finne ekte senter for player fordi jeg kan ikke endre den...
	var angle = other_pos.angle_to_point(global_position)
	angle = (angle * -1) + (PI *0.5)
	return angle


#func _on_timer_timeout():
	#print("1!")


func _on_gone_timer_timeout():
	#print("It's goning time!")
	#print("*gones all over the place* *pow*")
	#queue_free()
	remove_me(false)
	


func _on_area_detection_area_entered(area):
	if has_launched and not we_are_killed:
		we_are_killed = true
		remove_me(true)


func _on_area_detection_body_entered(body):
	# skjekker for  om vi er killed for å fikse en bug som oppstår når projectile er borti to killere samtidig
	if has_launched and not we_are_killed:
		we_are_killed = true
		remove_me(true)

func lower_gravity():
	print("gravity lowered")
	low_gravity = true
