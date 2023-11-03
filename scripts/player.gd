extends CharacterBody2D

@export var movement_data : PlayerMovementData

var air_jump = false
var just_wall_jumped = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var gravity_direction = 0
var rotation_speed = 10
var wanted_rotation = 0

var prevelocity = Vector2(0.0, 0.0)

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var coyotejump_timer = $CoyoteJumpTimer
@onready var rotation_timer = $RotationTimer
@onready var starting_position = global_position
@onready var gravity_detector = $GravityDetector

var debug = true

func _physics_process(delta):
	print("1, ",prevelocity)
	gravity_check()
	print("2, ",prevelocity)
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
	var radians = deg_to_rad(gravity_direction)
	
	up_direction = Vector2(sin(radians), -cos(radians))
	print(up_direction)
	velocity.x = prevelocity.x * cos(radians) - prevelocity.y * sin(radians)
	velocity.y = prevelocity.x * sin(radians) + prevelocity.y * cos(radians)
		
	rotation_degrees = move_toward(rotation_degrees, gravity_direction, rotation_speed)
	
	move_and_slide()
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
		
		if rotation_degrees > gravity_direction - 0.01 and rotation_degrees < gravity_direction + 0.01:
			gravity_direction = entered_area2d.area_direction
		var oldprevelocity = Vector2(prevelocity.x, prevelocity.y)
		
		var radians = deg_to_rad(gravity_direction)
		print("Radians: ", radians)
		# ÆÆÆÆÆÆÆÆÆÆÆÆ chatgpt help me

		prevelocity.x = (velocity.x * cos(radians) - velocity.y * sin(radians)) * -1
		prevelocity.y = (velocity.x * sin(radians) + velocity.y * cos(radians)) * -1

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
		var oldprevelocity = Vector2(prevelocity.x, prevelocity.y)
		var radians = deg_to_rad(gravity_direction)
		
		prevelocity.x = oldprevelocity.x * cos(radians) - oldprevelocity.y * sin(radians)
		prevelocity.y = oldprevelocity.x * sin(radians) + oldprevelocity.y * cos(radians)
#		if gravity_direction == 1:
#			prevelocity.x = -oldprevelocity.y
#			prevelocity.y = oldprevelocity.x
#		elif gravity_direction == 2:
#			prevelocity.y = -oldprevelocity.y
#			prevelocity.x = oldprevelocity.x
#		elif gravity_direction == 3:
#			prevelocity.x = oldprevelocity.y
#			prevelocity.y = -oldprevelocity.x
		gravity_direction = 0
