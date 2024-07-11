extends Camera2D

@export var random_strength = 2.5
@export var shake_fade = 10.0

var rng = RandomNumberGenerator.new()

var shake_strength = 0.0

func _ready():
	Events.pls_shake.connect(apply_shake)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if Input.is_action_just_pressed("musR"):
		#apply_shake()
	
	if shake_strength > 0.5:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		
		offset = random_offset()

func apply_shake():
	shake_strength = random_strength

func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength),rng.randf_range(-shake_strength, shake_strength))
