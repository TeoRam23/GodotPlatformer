extends CharacterBody2D

@export var movement_data : PlayerMovementData

var air_jump = true
var can_dash = true
var can_gigadash = true
var just_wall_jumped = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gonnadash = false
var sprite_rotation_speed = 100

var dashing = 250

var gravity_direction = 0
var rotation_speed = 15
var wanted_rotation = 0

var last_area
var last_grav

var prevelocity = Vector2(0.0, 0.0)

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var coyotejump_timer = $CoyoteJumpTimer
@onready var starting_position = global_position
@onready var gravity_detector = $GravityDetector
@onready var dash_charge_timer = $DashChargeTimer

@onready var camera = $Camera2D


@export var debug = true

func _physics_process(delta):
	gravity_check()
	button_presses(delta)
	
	var input_axis = Input.get_axis("left", "right")
	apply_gravity(delta)
	handle_wall_jump(input_axis)
	handle_jump()
	if debug and Input.is_key_pressed(KEY_F):
		if Input.is_key_pressed(KEY_CTRL):
			prevelocity.y = movement_data.jump_velocity
		else:
			prevelocity.y = movement_data.jump_velocity * 0.5
	handle_dash()
	handle_acceleration(input_axis, delta)
	handle_air_acceleration(input_axis, delta)
	apply_friction(input_axis, delta)
	apply_air_resistance(input_axis, delta)
	handle_gigadash(delta, input_axis)
	update_animation(input_axis)
	var was_on_floor = is_on_floor()

#	print("1, ",velocity, " og ", prevelocity) 
	if debug and Input.is_key_pressed(KEY_V):
		prevelocity.y = 0
	gravity_calculation()
	
	move_and_slide()
#	print("2, ",velocity, " og ", prevelocity)
	var just_left_ledge = was_on_floor and not is_on_floor() and prevelocity.y >= 0
	if just_left_ledge:
		coyotejump_timer.start()
	just_wall_jumped = false
	
	if position.y > 1350:
		position = starting_position
		prevelocity = Vector2(0, 0)

func apply_gravity(delta):
	if is_on_floor():
		prevelocity.y = 0
	if not is_on_floor():
		prevelocity.y += gravity * movement_data.gravity_scale * delta
		if is_on_wall() and prevelocity.y > 0:
			prevelocity.y = 40
	if is_on_ceiling() and not is_on_wall():
		prevelocity.y = 0.1

func handle_wall_jump(input_axis):
	if not is_on_wall_only(): #sjekker om man er ved siden av en vegg med bygd inn variabel
		return
	var wall_normal = get_wall_normal() #finner hvilken retning vegger peker
	prevelocity.x = 0
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
		var dash_axis = Input.get_axis("dashL", "dashR")
		if Input.is_action_just_pressed("dashL") or Input.is_action_just_pressed("dashR"):
			prevelocity.x += dashing * dash_axis
			if not debug:
				can_dash = false
				

func handle_gigadash(delta, input_axis):
	if is_on_floor(): can_gigadash = true
	
	elif not is_on_floor() and Input.is_action_just_pressed("down") and can_gigadash:
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
	if input_axis != 0:
		prevelocity.x = move_toward(prevelocity.x, movement_data.speed * input_axis, movement_data.acceleration * delta)
		

func handle_air_acceleration(input_axis, delta):
	if is_on_floor(): return
	if input_axis > 0 and prevelocity.x <= movement_data.speed * input_axis:
		prevelocity.x = move_toward(prevelocity.x, movement_data.speed * input_axis, movement_data.air_acceleration * delta)
	elif input_axis < 0 and prevelocity.x >= movement_data.speed * input_axis:
		prevelocity.x = move_toward(prevelocity.x, movement_data.speed * input_axis, movement_data.air_acceleration * delta)

func apply_friction(input_axis, delta):
	if (input_axis == 0 or Input.is_action_pressed("down")) and is_on_floor():
		prevelocity.x = move_toward(prevelocity.x, 0, movement_data.friction * delta)
		

func apply_air_resistance(input_axis, delta):
	if input_axis == 0 and not is_on_floor():
		prevelocity.x = move_toward(prevelocity.x, 0, movement_data.air_resistance)

func update_animation(input_axis):
	if input_axis != 0:
		if gravity_direction == 2:
			animated_sprite_2d.flip_h = (input_axis < 0)
		else:
			animated_sprite_2d.flip_h = (input_axis > 0)
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
		
	
	if not is_on_floor():
		animated_sprite_2d.play("jump")
	
	if (Input.is_action_pressed("down") and is_on_floor()) or gonnadash:
		animated_sprite_2d.play("crouch")


func _on_hazard_detector_area_entered(area):
	global_position = starting_position
	prevelocity = Vector2(0, 0)
	


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
		var entered_area2d = gravity_detector.get_overlapping_areas()[-1]
		
		if gravity_direction > 180:
			gravity_direction -= 360
		elif gravity_direction < -180:
			gravity_direction += 360
		if (rotation_degrees > gravity_direction - 0.01 and rotation_degrees < gravity_direction + 0.01):
#		if 1 == 1:
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
					last_area = entered_area2d
					last_grav = gravity_direction
					
					var cuisine = cos(radian_direction)
					var sine = sin(radian_direction)
					prevelocity.x = (velocity.x * cuisine + velocity.y * sine)
					prevelocity.y = (-velocity.x * sine + velocity.y * cuisine)
			else:
	#			var oldprevelocity = Vector2(prevelocity.x, prevelocity.y)
	#
				var radians = deg_to_rad(gravity_direction)
				
				if last_area != entered_area2d:
					last_area = entered_area2d
					
					
					print("#######################################################################ENTERED#######################################################################")
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
					
					var cuisine = cos(radians)
					var sine = sin(radians)
	#				cuisine = -cuisine
					print("cuisine: ", cuisine, " & sine: ", sine, "
vel.x: ", velocity.x, " & vel.y: ", velocity.y)
					
					prevelocity.x = (velocity.x * cuisine + velocity.y * sine)
					prevelocity.y = (-velocity.x * sine + velocity.y * cuisine)
					
					print("pre.x: ", prevelocity.x, " & pre.y: ", prevelocity.y)
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
			
	else:
		var radians = deg_to_rad(gravity_direction)
		prevelocity = prevelocity.rotated(radians)
		gravity_direction = 0
		last_area = Area2D
		
#		if gravity_direction == 1:
#			prevelocity.x = -oldprevelocity.y
#			prevelocity.y = oldprevelocity.x
#		elif gravity_direction == 2:
#			prevelocity.y = -oldprevelocity.y
#			prevelocity.x = oldprevelocity.x
#		elif gravity_direction == 3:
#			prevelocity.x = oldprevelocity.y
#			prevelocity.y = -oldprevelocity.x


func gravity_calculation():
	var radians = deg_to_rad(gravity_direction)
	velocity = prevelocity.rotated(radians)
#	up_direction = Vector2(sin(radians), -cos(radians))
	up_direction = Vector2.UP.rotated(radians)
	
	
	var target_angle = gravity_direction
	var current_angle = rotation_degrees

	var diff = target_angle - current_angle

	if diff > 180:
		diff -= 360
	elif diff < -180:
		diff += 360

	# Limit the rotation to a maximum of 45 degrees
	var move_rotation = clamp(diff, -rotation_speed, rotation_speed)

	# Apply the rotation
	rotation_degrees += move_rotation
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
		
		if camera.zoom >= Vector2(2, 2):
			camera.position_smoothing_enabled = false
			camera.rotation_smoothing_enabled = false
		else:
			camera.position_smoothing_enabled = true
			camera.rotation_smoothing_enabled = true
	
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
		
		if camera.zoom >= Vector2(2, 2):
			camera.position_smoothing_enabled = false
			camera.rotation_smoothing_enabled = false
		else:
			camera.position_smoothing_enabled = true
			camera.rotation_smoothing_enabled = true
	
	if Input.is_key_pressed(KEY_Z):
		camera.zoom = Vector2(1, 1)
		camera.position_smoothing_enabled = true
		camera.rotation_smoothing_enabled = true

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
			prevelocity.x = sqrt(gravity * movement_data.gravity_scale * distance) * prevelocity.x / abs(prevelocity.x)
			prevelocity.y = 0
			print(prevelocity.x)
			print("Gravity: ", gravity * movement_data.gravity_scale * 0.017, ", Delta: ", delta)
	if Input.is_key_pressed(KEY_H) and gravity_detector.get_overlapping_areas():
		var entered_area2d = gravity_detector.get_overlapping_areas()[0]
		var center = entered_area2d.global_position
		var distance = center.distance_to(global_position)
		print(distance)
