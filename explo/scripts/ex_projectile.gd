extends CharacterBody2D

var throw_power = -300
var angle = 0
var gravity_scale = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	var cuisine = cos(angle)
	var sine = sin(angle)
	
	velocity.x = (0 * cuisine + throw_power * sine)
	velocity.y = (0 * sine + throw_power * cuisine)
	#move_and_slide()


func _physics_process(delta):
	# Add the gravity.
	apply_gravity(delta)
	move_and_slide()


func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * gravity_scale * delta
