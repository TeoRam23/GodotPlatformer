extends Camera2D

@export var random_strength = 2.5
@export var shake_fade = 10.0
@export var do_shake = true

var rng = RandomNumberGenerator.new()

var shake_strength = 0.0
var first_frame = true

func _ready():
	if do_shake:
		Events.pls_shake.connect(apply_shake)
	Events.pls_camera_limit.connect(set_my_limit)
	await get_tree().create_timer(0.1).timeout

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	offset.x = 0
	if first_frame:
		position_smoothing_enabled = true
		first_frame = false
	#print("par: ",get_parent().get_parent().velocity)
	#print("mus: ",get_global_mouse_position())
	if Input.is_action_pressed("musR"):
		#print("OFFSETTING")
		offset.x = 0
	if shake_strength > 0.5:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		if shake_strength <= 0.5:
			offset = Vector2(0, 0)
			
			return
		offset = random_offset()
		
	#print("first: ", global_position)
	#
	#position = Vector2.ZERO
	#global_position.x = roundi(global_position.x)
	#global_position.y = roundi(global_position.y)
	#
	#print("second: ", global_position)
	

func apply_shake():
	shake_strength = random_strength

func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength),rng.randf_range(-shake_strength, shake_strength))
	
	

func set_my_limit(rd, lu):
	limit_right = rd.x
	limit_bottom = rd.y
	limit_left = lu.x
	limit_top = lu.y
