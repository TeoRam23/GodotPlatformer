extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var stage = get_tree().current_scene.name
	
	var world_number = stage.split()[0]
	
	material.set("shader_parameter/parent_id", int(world_number))
	#ShaderMaterial.set_shader_param("parent_id", hash(int(world_number)))
	
