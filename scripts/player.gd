extends CharacterBody2D

@export var movement_data : PlayerMovementData

var air_jump = false
var just_wall_jumped = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var gravity_direction = 0
var rotation_speed = 15
var wanted_rotation = 0

var last_area

var prevelocity = Vector2(0.0, 0.0)

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var coyotejump_timer = $CoyoteJumpTimer
@onready var rotation_timer = $RotationTimer
@onready var starting_position = global_position
@onready var gravity_detector = $GravityDetector

var debug = true

func _physics_process(delta):
	apply_gravity(delta)
	handle_wall_jump()
	handle_jump()
	var input_axis = Input.get_axis("left", "right")
	handle_acceleration(input_axis, delta)
	handle_air_acceleration(input_axis, delta)
	apply_friction(input_axis, delta)
	apply_air_resistance(input_axis, delta)
	update_animation(input_axis)
	var was_on_floor = is_on_floor()

	print("1, ",velocity, " og ", prevelocity)
	gravity_check()
	gravity_calculation()
	
	move_and_slide()
	print("2, ",velocity, " og ", prevelocity)
	var just_left_ledge = was_on_floor and not is_on_floor() and prevelocity.y >= 0
	if just_left_ledge:
		coyotejump_timer.start()
	just_wall_jumped = false

func apply_gravity(delta):
	if is_on_floor():
		prevelocity.y = 0
	if not is_on_floor():
		prevelocity.y += gravity * movement_data.gravity_scale * delta
		if is_on_wall() and prevelocity.y > 0:
			prevelocity.y = 40

func handle_wall_jump():
	if not is_on_wall_only(): #sjekker om man er ved siden av en vegg med bygd inn variabel
		return
	var wall_normal = get_wall_normal() #finner hvilken retning vegger peker
	if Input.is_action_just_pressed("jump"):
		if gravity_direction == 1:
			prevelocity.x = wall_normal.y * movement_data.speed
		elif gravity_direction == 3:
			prevelocity.x = -wall_normal.y * movement_data.speed
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
		if Input.is_action_just_released("jump") and prevelocity.y <  movement_data.jump_velocity / 2:
			prevelocity.y = movement_data.jump_velocity / 2
	
		if Input.is_action_just_pressed("jump") and air_jump and not just_wall_jumped:
			prevelocity.y = movement_data.jump_velocity * 0.8
			if not debug:
				air_jump = false

func handle_acceleration(input_axis, delta):
	if not is_on_floor() or Input.is_action_pressed("down"): return
	if input_axis != 0:
		prevelocity.x = move_toward(prevelocity.x, movement_data.speed * input_axis, movement_data.acceleration * delta)

func handle_air_acceleration(input_axis, delta):
	if is_on_floor(): return
	if input_axis != 0:
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
	
	if Input.is_action_pressed("down") and is_on_floor():
		animated_sprite_2d.play("crouch")


func _on_hazard_detector_area_entered(area):
	global_position = starting_position


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
#
#
		if rotation_degrees > gravity_direction - 0.01 and rotation_degrees < gravity_direction + 0.01:
			gravity_direction = entered_area2d.area_direction
	#			var oldprevelocity = Vector2(prevelocity.x, prevelocity.y)
	#
			var radians = deg_to_rad(gravity_direction)
			
			if last_area != entered_area2d:
				last_area = entered_area2d
				print("#######################################################################ENTERED#######################################################################")
				if gravity_direction == clamp(gravity_direction, 67.5, 112.5) or gravity_direction == clamp(gravity_direction, -112.5, -67.5) or gravity_direction == clamp(gravity_direction, 247.5, 292.5):
					prevelocity.x = (-1 * velocity.x * cos(radians) - velocity.y * sin(radians)) * -1
					prevelocity.y = (velocity.x * sin(radians) + velocity.y * cos(radians)) * -1
					print("hæ")
					
				elif gravity_direction == clamp(gravity_direction, 22.5, 67.5) or gravity_direction == clamp(gravity_direction, -67.5, -22.5) or gravity_direction == clamp(gravity_direction, 112.5, 157.5) or gravity_direction == clamp(gravity_direction, -157.5, -112.5):
					prevelocity.x = (-1 * velocity.x * cos(radians) - velocity.y * sin(radians)) * -0.707107
					prevelocity.y = (velocity.x * sin(radians) - velocity.y * cos(radians)) * -0.707107
					
				else:
					prevelocity.x = (velocity.x * cos(radians) - velocity.y * sin(radians))
					prevelocity.y = (velocity.x * sin(radians) + velocity.y * cos(radians))
					print("hoo")
		#
				print(velocity.x * cos(radians), " - ", velocity.y * sin(radians))
				print(velocity.x * sin(radians), " + ", velocity.y * cos(radians))
				print(prevelocity, ", velelv, ", velocity)
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
	up_direction = Vector2(sin(radians), -cos(radians))
	print(up_direction)
	# kanskje gjøre noe som gjør at den alltid gjør minimal spinning? aner ikke hvordan da
	rotation_degrees = move_toward(rotation_degrees, gravity_direction, rotation_speed)
	
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

