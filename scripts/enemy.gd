extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var movement_timer = $MovementTimer
@onready var wait_timer = $WaitTimer
@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_right = $RayCastRight

const SPEED = 1000.0
const JUMP_VELOCITY = -200.0
const gravity_scale = 0.8


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var start_moving = false
var parent
var player

func _ready():
	parent = get_parent()
	player = parent.get_node("Player")
	print(player.position.x)

func _physics_process(delta):
	apply_gravity(delta)
	handle_movement(delta)
	check_floor(delta)
	
	update_animation()


	move_and_slide()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * gravity_scale * delta

func handle_movement(delta):
	if wait_timer.time_left <= 0 and start_moving:
		var direction = randi_range(0,9)
		if direction <= 3:
			velocity.x = SPEED * sign(player.position.x - position.x) * delta
			print("agrip")
		elif direction == 4 or direction == 5:
			velocity.x = SPEED * sign(position.x - player.position.x) * delta
			print("retrett")
		elif direction >= 7:
			handle_jump()
		start_moving = false
		movement_timer.start()
	elif movement_timer.time_left <= 0 and not start_moving:
		velocity.x = 0
		wait_timer.start()
		start_moving = true
		

func handle_jump():
	if is_on_floor():
		velocity.y = JUMP_VELOCITY

func check_floor(delta):
	if velocity.x == 0:
		return
	if not ray_cast_left.is_colliding() and velocity.x < 0:
		velocity.x = SPEED * delta
	elif not ray_cast_right.is_colliding() and velocity.x > 0:
		velocity.x = -SPEED * delta


func update_animation():
	if not is_on_floor():
		if velocity.y < 0:
			animated_sprite_2d.play("jump")
		else:
			animated_sprite_2d.play("fall")
	else:
		animated_sprite_2d.play("default")
