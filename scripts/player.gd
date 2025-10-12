extends CharacterBody2D

@export var movement_data : PlayerMovementData
@export var low_gravity = false
@export var low_gravity_scale = 0.51
@export var low_gravity_fall_speed = 279
var main_data : PlayerMovementData

var air_jump = true
var can_dash = true
var can_gigadash = true
var just_wall_jumped = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gonnadash = false
var sprite_rotation_speed = 100
var just_launched = false
#var wrap_horizontal = false # ÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆ
#var wrap_vertical = false
#var rd = Vector2.ZERO
#var lu = Vector2.ZERO

var is_paused = false


var gravity_direction = 0
var rotation_speed = 15
var wanted_rotation = 0
var smooth_rotation = true

var rotation_divider = 15

var last_area
var last_grav

var prevelocity = Vector2(0.0, 0.0)

@onready var sprite_holder = $SpriteHolder
@onready var animated_sprite_2d = $SpriteHolder/AnimatedSprite2D
@onready var coyotejump_timer = $CoyoteJumpTimer
@onready var starting_position = global_position
@onready var gravity_detector = $GravityDetector
@onready var dash_charge_timer = $DashChargeTimer
@onready var collision_rect = $CollisionRect

@onready var icamera = $SpriteHolder/Camera2D
@onready var camera = $SpriteHolder/ExpoCamera

@onready var launch_particle = $LaunchParticle
@onready var dead_particle = $DeadParticle2
@onready var ground_poof_particle = $GroundPoofParticle2

@export var debug = true

@onready var timer = $Timer

var first_frame = true

var hot_air = false

func _ready():
	main_data = movement_data
	
	if movement_data.size != 1:
		scale.x = movement_data.size
		scale.y = movement_data.size
		print("###################### i have changed my size! ####################")
	
	Events.pls_kill_player.connect(i_died)
	Events.level_completed.connect(func(): disable_player(true))
	Events.pls_enter_extra.connect(func(): disable_player(false))
	#Events.pls_set_wrap.connect(wrap_me) # ÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆ
	
	if low_gravity:
		Events.low_gravity()
	if Settings.zero_gravity:
		movement_data.gravity_scale = 0
	johnnify()

func _physics_process(delta):
	
	if is_paused:
		return
	gravity_check()
	button_presses(delta)
	
	
	var input_axis = 0
	var real_axis = Input.get_axis("left", "right")
	if gravity_direction > 120 or gravity_direction < -120:
		real_axis *= -1
	if !Settings.no_walking:
		input_axis = real_axis
			
	
	apply_gravity(delta)
	handle_wall_jump(input_axis)
	handle_jump()
	if debug and Input.is_key_pressed(KEY_F):
		if Input.is_key_pressed(KEY_CTRL):
			prevelocity.y = -250
		else:
			prevelocity.y = -250 * 0.5
	handle_dash()
	handle_acceleration(input_axis, delta)
	handle_air_acceleration(input_axis, delta)
	apply_friction(input_axis, delta)
	apply_air_resistance(input_axis, delta)
	handle_gigadash(delta, input_axis)
	update_animation(input_axis, real_axis)
	
	var was_on_floor = is_on_floor()

#	print("1, ",velocity, " og ", prevelocity) 
	if debug and Input.is_key_pressed(KEY_V):
		prevelocity.y = 0
	gravity_calculation()
	
	
	
	if prevelocity.x > movement_data.max_speed:
		prevelocity.x = movement_data.max_speed
	elif prevelocity.x < -movement_data.max_speed:
		prevelocity.x = -movement_data.max_speed
	
	move_and_slide()
	
	if is_on_floor() and !was_on_floor and !first_frame:
		#print("WUÆÆÆÆÆÆÆ")
		ground_poof_particle.emitting = true
		
		
#	print("2, ",velocity, " og ", prevelocity)
	var just_left_ledge = was_on_floor and not is_on_floor() and prevelocity.y >= 0
	if just_left_ledge:
		coyotejump_timer.start()
	just_wall_jumped = false
	just_launched = false
	
	if position.y > 1350:
		position = starting_position
		prevelocity = Vector2(0, 0)
	
	
	#print(timer.time_left)
	
	# for å finne peak basert på en timer
	#if is_on_floor():
		#timer.stop()
	#if !is_on_floor() and timer.time_left <= 0:
		#timer.start()
	#if timer.time_left < 2.067 - 0.834 and timer.time_left > 2.067 - 0.917:
		#print("PEAK")
	#wrap_me(0,0,0,0) ÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆ
	first_frame = false
	hot_air = false

func apply_gravity(delta):
	#print(prevelocity.y)
	if is_on_floor():
		#print("floored, man")
		if !just_launched and prevelocity.y > 0:
			prevelocity.y = 0
			
	elif is_on_ceiling():
		if !just_launched:
			prevelocity.y = 0
	if not is_on_floor():
		if low_gravity:
			prevelocity.y += gravity * low_gravity_scale * movement_data.gravity_scale * delta
			if prevelocity.y > low_gravity_fall_speed:
				prevelocity.y -= low_gravity_fall_speed * 0.1
				if prevelocity.y < low_gravity_fall_speed:
					prevelocity.y = low_gravity_fall_speed
		else:
			prevelocity.y += gravity * movement_data.gravity_scale * delta
			if prevelocity.y > movement_data.max_fall_speed:
				prevelocity.y -= movement_data.max_fall_speed * 0.1
				if prevelocity.y < movement_data.max_fall_speed:
					prevelocity.y = movement_data.max_fall_speed
			
		
		
		if is_on_wall() and prevelocity.y > 0 and movement_data.wall_slide:
			prevelocity.y = 40

func handle_wall_jump(input_axis):
	if is_on_wall() and !just_launched:
		prevelocity.x = 0
	if not is_on_wall_only() or !movement_data.wall_slide: #sjekker om man er ved siden av en vegg med bygd inn variabel
		return
	var wall_normal = get_wall_normal() #finner hvilken retning vegger peker
	if Input.is_action_just_pressed("jump"):
		if gravity_direction == clamp(gravity_direction, 67.5, 112.5) or gravity_direction == clamp(gravity_direction, -112.5, -67.5):
			prevelocity.x = wall_normal.y * movement_data.speed * sign(gravity_direction)
#		elif gravity_direction == clamp(gravity_direction, -112.5, -67.5):
#			prevelocity.x = -wall_normal.y * movement_data.speed
		elif gravity_direction == clamp(gravity_direction, 157.5, 180):
			prevelocity.x = wall_normal.x * movement_data.speed * -1
		else:
			prevelocity.x = wall_normal.x * movement_data.speed
		prevelocity.y = movement_data.jump_velocity
		just_wall_jumped = true

func handle_jump():
	if movement_data.jump_velocity == 0:
		return
	if is_on_floor(): air_jump = true
	
	if is_on_floor() or coyotejump_timer.time_left > 0.0:
		if Input.is_action_just_pressed("jump"):
			prevelocity.y = movement_data.jump_velocity
	elif not is_on_floor():
		if Input.is_action_just_released("jump") and prevelocity.y <  movement_data.jump_velocity / 2 and prevelocity.y > movement_data.jump_velocity:
			prevelocity.y = movement_data.jump_velocity / 2 # aner ikke hvorfor dette var her? 
															# dette er her for å kunne hoppe lavere, dumme yngre meg
	
		if Input.is_action_just_pressed("jump") and air_jump and not just_wall_jumped:
			if prevelocity.y < movement_data.jump_velocity * 0.8:
				prevelocity.y += movement_data.jump_velocity * 0.1
			else:
				prevelocity.y = movement_data.jump_velocity * 0.8
#				print("less :)")
			if not debug:
				air_jump = false

func handle_dash():
	if is_on_floor(): can_dash = true
	
	elif not is_on_floor() and can_dash:
		var dash_axis = Input.get_axis("dashR", "dashL")
		if Input.is_action_just_pressed("dashL") or Input.is_action_just_pressed("dashR"):
			prevelocity.x += movement_data.jump_velocity * dash_axis
			if not debug:
				can_dash = false
				

func handle_gigadash(delta, input_axis):
	if is_on_floor(): can_gigadash = true
	
	elif not is_on_floor() and Input.is_action_just_pressed("down") and can_gigadash and movement_data.jump_velocity:
		gonnadash = true
		dash_charge_timer.start()
		animated_sprite_2d.rotation_degrees = 0
		if not debug:
			can_gigadash = false
	if gonnadash:
		prevelocity = Vector2(0, 0)
		animated_sprite_2d.rotation_degrees += 400 * input_axis * delta
		if animated_sprite_2d.rotation_degrees > 180:
				animated_sprite_2d.rotation_degrees -= 360
		elif animated_sprite_2d.rotation_degrees < -180:
				animated_sprite_2d.rotation_degrees += 360
				
		if dash_charge_timer.is_stopped() or Input.is_action_just_pressed("jump"):
			prevelocity = Vector2(0,movement_data.jump_velocity).rotated(animated_sprite_2d.rotation)
			
#			animated_sprite_2d.rotation_degrees = 0
			gonnadash = false
			
			sprite_rotation_speed = abs(animated_sprite_2d.rotation_degrees) * 5
	elif animated_sprite_2d.rotation_degrees != 0:
		animated_sprite_2d.rotation_degrees = move_toward(animated_sprite_2d.rotation_degrees, 0, sprite_rotation_speed * delta)


func handle_acceleration(input_axis, delta):
	if not is_on_floor() or Input.is_action_pressed("down"): return
	if input_axis > 0 and prevelocity.x <= movement_data.speed * input_axis:
		if prevelocity.x >= 0:
			prevelocity.x = movement_data.speed * input_axis
		else:
			prevelocity.x = move_toward(prevelocity.x, movement_data.speed * input_axis, movement_data.acceleration * delta)
	elif input_axis < 0 and prevelocity.x >= movement_data.speed * input_axis:
		if prevelocity.x <= 0:
			prevelocity.x = movement_data.speed * input_axis
		else:
			prevelocity.x = move_toward(prevelocity.x, movement_data.speed * input_axis, movement_data.acceleration * delta)
		

func handle_air_acceleration(input_axis, delta):
	if is_on_floor(): return
	if input_axis > 0 and prevelocity.x <= movement_data.speed * input_axis:
		prevelocity.x = move_toward(prevelocity.x, movement_data.speed * input_axis, movement_data.air_acceleration * delta)
	elif input_axis < 0 and prevelocity.x >= movement_data.speed * input_axis:
		prevelocity.x = move_toward(prevelocity.x, movement_data.speed * input_axis, movement_data.air_acceleration * delta)

func apply_friction(input_axis, delta):
	if (input_axis == 0 or Input.is_action_pressed("down")) and is_on_floor() and !just_launched:
		if abs(prevelocity.x) <= movement_data.speed:
			prevelocity.x = 0
		else:
			prevelocity.x = move_toward(prevelocity.x, 0, movement_data.friction * delta)
		

func apply_air_resistance(input_axis, delta):
	if input_axis == 0 and not is_on_floor():
		prevelocity.x = move_toward(prevelocity.x, 0, movement_data.air_resistance)

func update_animation(input_axis, real_axis):
	if real_axis != 0:
		animated_sprite_2d.flip_h = (real_axis > 0)
	
	if input_axis != 0:
		
		if abs(prevelocity.x) > movement_data.speed * 8:
			animated_sprite_2d.speed_scale = 4
			animated_sprite_2d.play("runner")
		elif abs(prevelocity.x) > movement_data.speed * 2:
			animated_sprite_2d.speed_scale = 2
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.speed_scale = 1
			animated_sprite_2d.play("run")
	elif Input.is_action_pressed("up"):
		animated_sprite_2d.play("look_up")
	else:
		animated_sprite_2d.play("idle")
		
	#print("vel: ",prevelocity.y)
	#print(hot_air)
	#print("pos: ", position.y)
	if not is_on_floor():
		if prevelocity.y < 0 or (hot_air and prevelocity.y < 30):
			animated_sprite_2d.play("jump")
		else:
			animated_sprite_2d.play("fall")
	
	if (Input.is_action_pressed("down") and is_on_floor()) or gonnadash:
		animated_sprite_2d.play("crouch")


func _on_hazard_detector_area_entered(area):
	call_deferred("i_died")
	
func _on_hazard_detector_body_entered(body):
	if body.is_in_group("ForegroundGroup"):
		print("WE GOT THE MAP")
		body.fade_away()
		return
	call_deferred("i_died")


func disable_player(do_particles: bool):
	set_physics_process(false)
	animated_sprite_2d.visible = false
	launch_particle.emitting = false
	dead_particle.emitting = do_particles

func enable_player():
	set_physics_process(true)
	animated_sprite_2d.visible = true

func i_died():
	if is_physics_processing():
		disable_player(true)
		#get_tree().paused = true
		Events.player_died()
		#get_tree().reload_current_scene()
		#global_position = starting_position
		#prevelocity = Vector2(0, 0)

#func _on_gravity_detector_area_entered(area):
#	var entered_area2d = area
#	var direction = entered_area2d.area_direction
#
#	gravity_direction = direction
#	var oldprevelocity = Vector2(prevelocity.x, prevelocity.y)
#	if gravity_direction == 1:
#		prevelocity.x = velocity.y
#		prevelocity.y = -velocity.x
#	elif gravity_direction == 2:
#		prevelocity.y = -velocity.y
#		prevelocity.x = velocity.x
#	elif gravity_direction == 3:
#		prevelocity.x = -velocity.y
#		prevelocity.y = velocity.x
#
#
#func _on_gravity_detector_area_exited(area): #dette er ikke bra, finn på noe annet kanskje? vet ikke lenger
#	if not gravity_detector.get_overlapping_areas():
#		var oldprevelocity = Vector2(prevelocity.x, prevelocity.y)
#		if gravity_direction == 1:
#			prevelocity.x = -oldprevelocity.y
#			prevelocity.y = oldprevelocity.x
#		elif gravity_direction == 2:
#			prevelocity.y = -oldprevelocity.y
#			prevelocity.x = oldprevelocity.x
#		elif gravity_direction == 3:
#			prevelocity.x = oldprevelocity.y
#			prevelocity.y = -oldprevelocity.x
#		gravity_direction = 0


func gravity_check():
	if gravity_detector.get_overlapping_areas():
		var entered_area2d = gravity_detector.get_overlapping_areas()[0]
		for area in gravity_detector.get_overlapping_areas():
			if area.on_top:
				entered_area2d = area
		
		if entered_area2d.is_in_group("explo_gravity"):
			smooth_rotation = false
		else:
			smooth_rotation = true
		
		if gravity_direction > 180:
			gravity_direction -= 360
		elif gravity_direction < -180:
			gravity_direction += 360
			
			
		gravity_direction = entered_area2d.area_direction
		
		if gravity_direction == 123456 or gravity_direction == -123456:
			
#				for area in gravity_detector.get_overlapping_areas():
#					if (area.area_direction == -123456 or area.area_direction == 123456) and area != entered_area2d:
#						entered_area2d = area
#						gravity_direction = area.area_direction
#						break
			var relative_position = entered_area2d.global_position - global_position
			var angle_to_target = relative_position.angle()
			var radian_direction = angle_to_target
#				print(gravity_direction / 123456)
			gravity_direction = rad_to_deg(radian_direction) -  (90 * (gravity_direction / 123456))
			radian_direction = deg_to_rad(gravity_direction)

			if last_area != entered_area2d or last_grav != gravity_direction:
				find_diff_rotate(gravity_direction)
				
				last_area = entered_area2d
				last_grav = gravity_direction
				
				
				var cuisine = cos(radian_direction)
				var sine = sin(radian_direction)
				prevelocity.x = (velocity.x * cuisine + velocity.y * sine)
				prevelocity.y = (-velocity.x * sine + velocity.y * cuisine)
		else:
#			var oldprevelocity = Vector2(prevelocity.x, prevelocity.y)
			var radians = deg_to_rad(gravity_direction)
			
			if last_area != entered_area2d:
				last_area = entered_area2d
				find_diff_rotate(gravity_direction)
				
				#print("#######################################################################ENTERED#######################################################################")
				
				
#				if gravity_direction > 180:
#					gravity_direction -= 360
#				elif gravity_direction < -180:
#					gravity_direction += 360
					
#				if gravity_direction == clamp(gravity_direction, 67.5, 112.5) or gravity_direction == clamp(gravity_direction, -112.5, -67.5):
#					prevelocity.x = (velocity.x * cos(radians) - velocity.y * sin(radians)) * -1
#					prevelocity.y = (velocity.x * sin(radians) + velocity.y * cos(radians)) * -1
##					print("hæ")
#
#				elif gravity_direction == clamp(gravity_direction, 22.5, 67.5) or gravity_direction == clamp(gravity_direction, -67.5, -22.5) or gravity_direction == clamp(gravity_direction, 112.5, 157.5) or gravity_direction == clamp(gravity_direction, -157.5, -112.5):
#					prevelocity.x = (-1 * velocity.x * cos(radians) - velocity.y * sin(radians)) * -0.707107
#					prevelocity.y = (velocity.x * sin(radians) - velocity.y * cos(radians)) * -0.707107
#
#				else:
#					prevelocity.x = (velocity.x * cos(radians) - velocity.y * sin(radians))
#					prevelocity.y = (velocity.x * sin(radians) + velocity.y * cos(radians))
					
					
#					print("hoo")
#				rotation_speed = abs(abs(rotation_degrees) - abs(gravity_direction))# / rotation_divider
				
				
				var cuisine = cos(radians)
				var sine = sin(radians)
#				cuisine = -cuisine
				#print("cuisine: ", cuisine, " & sine: ", sine, "
#vel.x: ", velocity.x, " & vel.y: ", velocity.y)
				
				prevelocity.x = (velocity.x * cuisine + velocity.y * sine)
				prevelocity.y = (-velocity.x * sine + velocity.y * cuisine)
				
				#print("pre.x: ", prevelocity.x, " & pre.y: ", prevelocity.y)
			#
	#				print(velocity.x * cos(radians), " - ", velocity.y * sin(radians))
	#				print(velocity.x * sin(radians), " + ", velocity.y * cos(radians))
	#				print(prevelocity, ", velelv, ", velocity)
					# ÆÆÆÆÆÆÆÆÆÆÆÆ chatgpt help me
	#				prevelocity.x = (velocity.x * cos(radians) - velocity.y * sin(radians)) * -1
	#				prevelocity.y = (velocity.x * sin(radians) + velocity.y * cos(radians)) * -1
#
			#90up = (-1, 0)
			
#			prevelocity.x = (velocity.x * cos(radians) - velocity.y * sin(radians)) * 1
#			prevelocity.y = (velocity.x * sin(radians) + velocity.y * cos(radians)) * 1
			#180up = (0, 1)

#			prevelocity.x = (velocity.x * cos(radians) - velocity.y * sin(radians)) * 0.707107 
#			prevelocity.y = (velocity.x * sin(radians) + velocity.y * cos(radians)) * 0.707107
			#45up = (0.707107, -0.707107)
			
#			prevelocity.x = (velocity.x * cos(radians) - velocity.y * sin(radians)) * -0.965926
#			prevelocity.y = (velocity.x * sin(radians) + velocity.y * cos(radians)) * -0.258819
			#-75up = (-0.965926, -0.258819)
			
#			prevelocity.x = (velocity.x * cos(radians) - velocity.y * sin(radians)) * -0.965926
#			prevelocity.y = (velocity.x * sin(radians) + velocity.y * cos(radians)) * -0.258819
			#75up = (0.965926, -0.258819)
			
#			prevelocity.x = (velocity.x * cos(radians) - velocity.y * sin(radians)) * -0.642788
#			prevelocity.y = (velocity.x * sin(radians) + velocity.y * cos(radians)) * 0.766044 nopp
			#140up = (0.642788, 0.766044)
			
			#230up = (-0.766044, 0.642788)

	#		if gravity_direction == 90:
	#			prevelocity.x = velocity.y
	#			prevelocity.y = -velocity.x
	#		elif gravity_direction == 180:
	#			prevelocity.y = -velocity.y
	#			prevelocity.x = -velocity.x
	#		elif gravity_direction == -90:
	#			prevelocity.x = -velocity.y
	#			prevelocity.y = velocity.x
	#		else:
	#			prevelocity.x = velocity.x
	#			prevelocity.y = velocity.y
		if gravity_direction > 180:
			gravity_direction -= 360
		elif gravity_direction < -180:
			gravity_direction += 360
			
	else:
		var radians = deg_to_rad(gravity_direction)
		prevelocity = prevelocity.rotated(radians)
		gravity_direction = 0
		if last_area != Area2D:
			find_diff_rotate(0)
		last_area = Area2D
	
	if smooth_rotation:
		# fjerner kollisjon fra rektangelet mens sprite roterer for å hindre rarheter hvis toppen går roteres inn i et tak/vegg
		if sprite_holder.rotation_degrees != 0:
			collision_rect.disabled = true
		else:
			collision_rect.disabled = false
	else:
		collision_rect.disabled = false
		
#		if gravity_direction == 1:
#			prevelocity.x = -oldprevelocity.y
#			prevelocity.y = oldprevelocity.x
#		elif gravity_direction == 2:
#			prevelocity.y = -oldprevelocity.y
#			prevelocity.x = oldprevelocity.x
#		elif gravity_direction == 3:
#			prevelocity.x = oldprevelocity.y
#			prevelocity.y = -oldprevelocity.x


func find_diff_rotate(grav):
	var diff = grav - rotation_degrees

	if diff > 180:
		diff -= 360
	elif diff < -180:
		diff += 360
		
		
	if smooth_rotation:
		sprite_holder.rotation_degrees -= diff
		
		while sprite_holder.rotation_degrees > 180 or sprite_holder.rotation_degrees < -180:
			if sprite_holder.rotation_degrees > 180:
				sprite_holder.rotation_degrees -= 360
			elif sprite_holder.rotation_degrees < -180:
				sprite_holder.rotation_degrees += 360
	
	else:
		sprite_holder.rotation_degrees = 0
		var cuisine = cos(deg_to_rad(grav))
		var sine = sin(deg_to_rad(grav))
		position.x += (0 * cuisine + 2 * sine)
		position.y += (0 * sine + 2 * cuisine)
	
	rotation_degrees = grav

func gravity_calculation():
	var radians = deg_to_rad(gravity_direction)
	velocity = prevelocity.rotated(radians)
#	up_direction = Vector2(sin(radians), -cos(radians))

	up_direction = Vector2.UP.rotated(radians)
	
	
	
	var target_angle = 0
#	var target_angle = gravity_direction
	var current_angle = sprite_holder.rotation_degrees

	var diff = target_angle - current_angle
	
	while diff > 180 or diff < -180:
		if diff > 180:
			diff -= 360
		elif diff < -180:
			diff += 360

	# Limit the rotation to a maximum of 45 degrees
	var move_rotation = clamp(diff, -rotation_speed, rotation_speed)

	# Apply the rotation
	if smooth_rotation:
		sprite_holder.rotation_degrees += move_rotation #Gjorde dette bra bedre! yay!
	# Og forresten så fikset problemer når du går inn i area og hodet blir rotert inn i et tak. fikset det også! YAY!
	
#	if (rotation_degrees > gravity_direction - 0.01 and rotation_degrees < gravity_direction + 0.01):
#		print("IIIIIIIIIIIIIIIIII")
#		collision_rect.disabled = false
#		collision_sphere.disabled = true
#	else:
#		print("OOOOOOOOOOOOOOOOOOOOOO")
#		collision_rect.disabled = true
#		collision_sphere.disabled = false
#	print("UP: ", up_direction)
#	print(up_direction)
#	var differanse = abs(abs(rotation_degrees)-abs(gravity_direction))



#	var differanse
#	var rotation_aim
#	if rotation_degrees > gravity_direction:
#		differanse = rotation_degrees - gravity_direction
#	else:
#		differanse = gravity_direction - rotation_degrees
#
#	if differanse != 0:
#		print(differanse)
#	if differanse > 180:
#		print("oOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOo")
#		rotation_aim = gravity_direction * -1
#	else:
#		rotation_aim = gravity_direction
#	rotation_degrees = move_toward(rotation_degrees, rotation_aim, rotation_speed)
	
	
	
#	if gravity_direction == 1:
#		up_direction = Vector2(1, 0)
#		velocity.x = -prevelocity.y
#		velocity.y = prevelocity.x
#		wanted_rotation = 90
#	elif gravity_direction == 2:
#		up_direction = Vector2(0, 1)
#		velocity.x = prevelocity.x
#		velocity.y = -prevelocity.y
#		wanted_rotation = 179.99
#	elif gravity_direction == 3:
#		up_direction = Vector2(-1, 0)
#		velocity.x = prevelocity.y
#		velocity.y = -prevelocity.x
#		wanted_rotation = -90
#	else:
#		up_direction = Vector2(0, -1)
#		velocity.x = prevelocity.x
#		velocity.y = prevelocity.y
#		wanted_rotation = 0

	
#	if gravity_detector.get_overlapping_areas():
#		var entered_area2d = gravity_detector.get_overlapping_areas()[-1]
#		if last_area != entered_area2d:
#			last_area = entered_area2d
	
#	else:
#		velocity = prevelocity
#		print("")
	
	
#	velocity.x = prevelocity.x * cos(radians) - prevelocity.y * sin(radians)
#	velocity.y = prevelocity.x * sin(radians) + prevelocity.y * cos(radians)


func launch_me(angle, power):
	#print("MY ANGLE: ",rad_to_deg(angle))
	#power = -410
	var cuisine = cos(angle)
	var sine = sin(angle)
	velocity.x += (0 * cuisine + power * sine)
	velocity.y += (0 * sine + power * cuisine)
	
	prevelocity = velocity.rotated(deg_to_rad(-gravity_direction))
	
	launch_particle.direction = Vector2(sine, cuisine).rotated(PI)
	
	#launch_particle.restart()
	launch_particle.emitting = true
	
	#print(prevelocity)
	#if prevelocity.y < power * 1:
		#prevelocity.y = power * 1
	
	just_launched = true
	
	#print("I hast launched 3 ", process_priority)

#func wrap_me(srd, slu, wr_horz, wr_vert): ÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆ
	#if srd or slu:
		#rd = srd
		#lu = slu
		#wrap_horizontal = wr_horz
		#wrap_vertical = wr_vert
	##print("sending... ", srd, ", ", slu, ", ", wr_horz, wr_vert)
	##(320, 124) and: (-320, -236)
	##var rd = Vector2(320, 124)
	##var lu = Vector2(-320, -236)
	#if wrap_horizontal:
		#if global_position.x > rd.x + 8:
			#global_position.x = lu.x - 8
		#if global_position.x < lu.x - 8:
			#global_position.x = rd.x + 8
	#if wrap_vertical:
		#if global_position.y > rd.y + 8:
			#global_position.y = lu.y - 8
		#if global_position.y < lu.y - 8:
			#global_position.y = rd.y + 8



func button_presses(delta):
#	if is_on_wall():
#		print("WALL!")
#	else:
#		print("no wall :[")
	if Input.is_action_just_pressed("rotate"):
		if camera.ignore_rotation == true:
			camera.ignore_rotation = false
		else:
			camera.ignore_rotation = true
	if Input.is_action_just_pressed("pluss"):
		if camera.zoom < Vector2(0.0999, 0.0999):
			camera.zoom = Vector2(camera.zoom.x * 1.25, camera.zoom.x * 1.25)
		elif camera.zoom < Vector2(1, 1):
			camera.zoom += Vector2(0.1, 0.1)
		elif camera.zoom >= Vector2(10, 10):
			camera.zoom += Vector2(10, 10)
		else:
			camera.zoom += Vector2(1, 1)
		print(camera.zoom)
		
		#if camera.zoom >= Vector2(2, 2):
			#camera.position_smoothing_enabled = false
			#camera.rotation_smoothing_enabled = false
		#else:
			#camera.position_smoothing_enabled = true
			#camera.rotation_smoothing_enabled = true
	
	elif Input.is_action_just_pressed("minus"):
		if camera.zoom <= Vector2(0.1, 0.1):
			camera.zoom = Vector2(camera.zoom.x * 0.8, camera.zoom.x * 0.8)
		elif camera.zoom <= Vector2(1, 1):
			camera.zoom -= Vector2(0.1, 0.1)
		elif camera.zoom > Vector2(10, 10):
			camera.zoom -= Vector2(10, 10)
		else:
			camera.zoom -= Vector2(1, 1)
		print(camera.zoom)
		
		#if camera.zoom >= Vector2(2, 2):
			#camera.position_smoothing_enabled = false
			#camera.rotation_smoothing_enabled = false
		#else:
			#camera.position_smoothing_enabled = true
			#camera.rotation_smoothing_enabled = true
	
	if Input.is_key_pressed(KEY_Z):
		camera.zoom = Vector2(1, 1)
		#camera.position_smoothing_enabled = true
		#camera.rotation_smoothing_enabled = true

	if Input.is_key_pressed(KEY_H) and gravity_detector.get_overlapping_areas():
		var entered_area2d = gravity_detector.get_overlapping_areas()[0]
		var center = entered_area2d.global_position
		var distance = center.distance_to(global_position)
		print(distance)
	
	if debug:
		if Input.is_key_pressed(KEY_G):
			if gravity_detector.get_overlapping_areas():
				var entered_area2d = gravity_detector.get_overlapping_areas()[0]
				var center = entered_area2d.global_position
				var distance = center.distance_to(global_position)
	#			var multiplier
	#			if prevelocity.x <= 0:
	#				multiplier = -1
	#			else: 
	#				multiplier = 1
	#			prevelocity.x = sqrt(gravity * movement_data.gravity_scale * distance) * multiplier
				prevelocity.x = sqrt(gravity * movement_data.gravity_scale * distance) * sign(prevelocity.x)
				prevelocity.y = 0
				print(prevelocity.x)
				print("Gravity: ", gravity * movement_data.gravity_scale * 0.017, ", Delta: ", delta)
		
		if Input.is_key_pressed(KEY_U):
			rotation_degrees += 5
			print(position)
		if Input.is_key_pressed(KEY_Y):
			rotation_degrees -= 5
			print(position)


func johnnify():
	if VariableManager.johnny_mode:
		animated_sprite_2d.use_parent_material = false
		dead_particle.color = Color(0.263, 0.482, 0.851)
		#launch_particle.modulate = Color(0.504, 0.694, 0.84)
	else:
		animated_sprite_2d.use_parent_material = true
		dead_particle.color = Color(0.81, 0.324, 0.34)
		#launch_particle.modulate = Color(0.839, 0.525, 0.502)

func _input(event):
	if Input.is_action_just_pressed("musR"):
		VariableManager.johnny_mode = !VariableManager.johnny_mode
		johnnify()

#func _on_timer_timeout():
	#print("BOTT!")
