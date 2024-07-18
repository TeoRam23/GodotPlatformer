extends StaticBody2D

@onready var launch_timer = $LaunchTimer
@onready var shoop_particle = $ShoopParticle

const ARROW_HAZARD = preload("res://explo/hazards/arrow_hazard.tscn")
@export var arrow_speed = -180.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_launch_timer_timeout():
	var new_arrow = ARROW_HAZARD.instantiate()
	new_arrow.velocity = Vector2.RIGHT.rotated(rotation) * arrow_speed
	
	shoop_particle.emitting = true
	
	add_child(new_arrow)
