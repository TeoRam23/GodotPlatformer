extends StaticBody2D

@export var dissa_id = 1
@export var delay_time = 1.0
var activated = false

@onready var animated_sprite = $AnimatedSprite2D
@onready var shplipp_particle = $ShplippParticle

# Called when the node enters the scene tree for the first time.
func _ready():
	var stage = get_tree().current_scene.name
	
	var world_number = stage.split()[0]
	
	material.set("shader_parameter/parent_id", int(world_number))
	
	if world_number == "5":
		animated_sprite.visible = false
		animated_sprite = $AnimatedMush2D
		animated_sprite.visible = true
		
		shplipp_particle.color = Color(0.455, 1.0, 0.914)
	#shplipp_particle.material.set("shader_parameter/parent_id", int(world_number))


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
