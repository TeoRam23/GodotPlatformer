extends CPUParticles2D

var has_emitted = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if emitting:
		has_emitted = true
	elif has_emitted and !emitting:
		queue_free()
