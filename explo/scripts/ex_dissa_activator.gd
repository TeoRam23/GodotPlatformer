extends StaticBody2D

@export var dissa_id = 1
@export var delay_time = 1.0
var activated = false

@onready var animated_sprite = $AnimatedSprite2D
@onready var shplipp_particle = $ShplippParticle

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func explode():
	if !activated:
		activated = true
		
		animated_sprite.set_frame_and_progress(1, 0)
		shplipp_particle.emitting = true
		
		var dissablocks = get_tree().get_nodes_in_group("DissaBlock")
		for block in dissablocks:
			if block.dissa_id == dissa_id:
				block.activate_dissablock(delay_time)
