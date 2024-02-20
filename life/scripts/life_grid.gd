extends TileMap

func _process(delta):
	if Input.is_action_just_pressed("LMB"):
		var tile : Vector2 = local_to_map(get_global_mouse_position())
		print(tile)
		set_cell(0, tile)
