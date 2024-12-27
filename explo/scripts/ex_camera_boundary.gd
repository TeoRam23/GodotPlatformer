extends CollisionShape2D

@export var camera_zone = false

@export var wrap_horizontal = false
@export var wrap_vertical = false
var rd
var lu

@onready var up_particle = $UpParticle
@onready var down_particle = $DownParticle
@onready var left_particle = $LeftParticle
@onready var right_particle = $RightParticle

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.pls_request_wrap.connect(requester_wrap)
	
	rd = shape.extents
	print(rd)
	lu = rd * -1
	rd += global_position
	lu += global_position
	
	# calls deferred fordi hvis den kjører funskjonen med en gang har ikke kameraet connecta til events
	call_deferred("send_signal")
	if wrap_horizontal or wrap_vertical:
		call_deferred("send_wrap")
	
	set_particles()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func send_signal():
	Events.set_camera_limit(rd, lu)

func send_wrap():
	Events.set_wrapping(rd, lu, wrap_horizontal, wrap_vertical)


func set_particles():
	var shaper = shape.get_rect()
	
	print("shape x: ",shape.get_rect().size.x)
	if wrap_vertical:
		up_particle.emitting = true
		up_particle.amount = shape.get_rect().size.x * 0.1171875
		up_particle.emission_rect_extents.x = shaper.size.x * 0.5
		up_particle.position.x = 0
		up_particle.position.y = shaper.size.y * -0.5
		
		down_particle.emitting = true
		down_particle.amount = shape.get_rect().size.x * 0.1171875
		down_particle.emission_rect_extents.x = shaper.size.x * 0.5
		down_particle.position.x = 0
		down_particle.position.y = shaper.size.y * 0.5
	
	if wrap_horizontal:
		left_particle.emitting = true
		left_particle.amount = shape.get_rect().size.y * 0.1171875
		left_particle.emission_rect_extents.y = shaper.size.y * 0.5
		left_particle.position.y = 0
		left_particle.position.x = shaper.size.x * -0.5
		
		right_particle.emitting = true
		right_particle.amount = shape.get_rect().size.y * 0.1171875
		right_particle.emission_rect_extents.y = shaper.size.y * 0.5
		right_particle.position.y = 0
		right_particle.position.x = shaper.size.x * 0.5


func requester_wrap(requester):
	if requester.has_method("wrap_me"):
		requester.wrap_me(rd, lu, wrap_horizontal, wrap_vertical)
