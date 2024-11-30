extends CharacterBody2D

@export var speed = 300.0
@export var jump_velocity = 0
@export var gravity_multiplier = 0.69
@export var max_down_velocity = 300

var lava_can_kill = false

var start_pos = Vector2(0, 0)


@onready var face_sprite = $FaceSprite
# -142.0 for 1 block
# -323.5 for 5 block
# -601.0 for 17 block
# -460.0 for 10 block
# y = −0.03486x − 3.9499
# y = block
# x = velocetey

# x = (𝑦+3,9499)/(−0,03486)


# m=-3.485838779956427
# b=3.94989106753812634

# x=(𝑦+3.94989106753812634)/(-0.03485838779956427)

#y−y1 = m(x − x1)
# lineært virket ikke... ÆÆÆÆÆ

var activated = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#ÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆ har ikke testet velocity.x og om det er likkens ÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆ
#ok

func _ready():
	start_pos = position
	
	# kalkulerer velocetey for hvor høyt den skal hoppe
	#jump_velocity = (-0.000463931+sqrt(-0.000463931**2 - (0.000185132*(0.0007942-(blocks_tall+(extra_pxl*0.0625))))))/(0.000046283*2) *-1


func _physics_process(delta):
	var collision = move_and_slide()
	if collision:
		if is_on_wall():
		
			velocity.x = speed * -get_wall_normal().x

	update_face()
	# Add the gravity.
	if not is_on_floor() and activated:
		if velocity.y < max_down_velocity:
			velocity.y += gravity * delta * gravity_multiplier
		if velocity.y >= max_down_velocity:
			velocity.y = max_down_velocity
	

	# Handle jump.
	if Input.is_action_just_pressed("back"):
		velocity.y = jump_velocity
		#y=0.000046283x^{2}+-0.000463931\left(x\right)+0.0007942
		#velocity.y =  #/ 17 * blocks_tall
		
		#velocity.y = (-0.000463931+sqrt(-0.000463931**2 - (0.000185132*(0.0007942-(blocks_tall+(extra_pxl*0.0625))))))/(0.000046283*2) *-1
		print(velocity.y)
		#velocity.y = 601

		
		activated = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)


#func _process(delta):
	#if timer.time_left < 1.184 and timer.time_left > 1.1:
		#print("TOPPERS")


func reset_bubble():
	#print("Killed")
	position = start_pos
	# stop partikler
	activated = false
	lava_can_kill = false
	velocity = Vector2.ZERO


func launch_bubble():
	#print("Let's-a go!")
	velocity.y = jump_velocity
	velocity.x = speed
	activated = true


func _on_lava_detector_body_entered(body):
	#print("I do see you ", lava_can_kill)
	if lava_can_kill:
		reset_bubble()


func _on_lava_detector_body_exited(body):
	#print("I live!")
	lava_can_kill = true


func update_face():
	if velocity.x > 0:
		face_sprite.position.x = 1
	elif velocity.x < 0:
		face_sprite.position.x = -1
	else:
		face_sprite.position.x = 0
	if velocity.y > 0:
		face_sprite.position.y = 1
	elif velocity.y < 0:
		face_sprite.position.y = -1
	else:
		face_sprite.position.y = 0
