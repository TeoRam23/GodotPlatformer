extends CharacterBody2D
@onready var timer = $Timer


@export var SPEED = 300.0
@export var JUMP_VELOCITY = -601.0
@export var gravity_multiplier = 0.69
@export var max_down_velocity = 300

var activated = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#ÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆ dette er ikke ferdig dude ÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆ

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor() and activated:
		if velocity.y < max_down_velocity:
			velocity.y += gravity * delta * gravity_multiplier
		if velocity.y >= max_down_velocity:
			velocity.y = max_down_velocity

	# Handle jump.
	if Input.is_action_just_pressed("back"):
		timer.start()
		velocity.y = JUMP_VELOCITY
		activated = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _process(delta):
	if timer.time_left < 1.184 and timer.time_left > 1.1:
		print("TOPPERS")

func _on_timer_timeout():
	print("2 sec")
