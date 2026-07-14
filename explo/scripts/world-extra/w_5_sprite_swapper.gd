extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var stage = get_tree().current_scene.name
	
	var world_number = stage.split()[0]
	
	if int(world_number) == 5:
		var children = get_children()
		
		for child in children:
			if child.is_in_group("sprite_to_hide"):
				child.visible = false
			elif child.is_in_group("sprite_to_show"):
				child.visible = true
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
