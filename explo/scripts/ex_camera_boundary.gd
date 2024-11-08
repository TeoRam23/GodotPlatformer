extends CollisionShape2D

@export var camera_zone = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var rd = shape.extents
	print(rd)
	var lu = rd * -1
	rd += global_position
	lu += global_position
	
	# calls deferred fordi hvis den kjører funskjonen med en gang har ikke kameraet connecta til events
	call_deferred("send_signal", rd, lu)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func send_signal(rd, lu):
	Events.set_camera_limit(rd, lu)
