extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var movement_timer = $MovementTimer
@onready var wait_timer = $WaitTimer

const SPEED = 1000.0
const JUMP_VELOCITY = -125.0
const gravity_scale = 0.8


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var start_moving = false



func _physics_process(delta):
	# Add the gravity.
	apply_gravity(delta)
	handle_movement(delta)
	
	update_animation()


	move_and_slide()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * gravity_scale * delta

func handle_movement(delta):
	if movement_timer.time_left <= 0 and start_moving:
		var direction = randi_range(0,3)
		if direction == 0:
			velocity.x = -SPEED * delta
		elif direction == 1:
			velocity.x = SPEED * delta
		elif direction == 2:
			handle_jump()
		start_moving = false
		wait_timer.start()
		print("hoi")
	elif wait_timer.time_left <= 0 and not start_moving:
		velocity.x = 0
		movement_timer.start()
		start_moving = true
		print("ioh")
		

func handle_jump():
	if is_on_floor():
		velocity.y = JUMP_VELOCITY

func update_animation():
	if not is_on_floor():
		if velocity.y < 0:
			animated_sprite_2d.play("jump")
		else:
			animated_sprite_2d.play("fall")
	else:
		animated_sprite_2d.play("default")
