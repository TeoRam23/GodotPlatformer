extends HSlider

var my_settings: String

# Called when the node enters the scene tree for the first time.
func _ready():
	#Events.connect("save_my_settings", pls_save)
	Events.pls_save_settings_yall.connect(save_my_settings)
	my_settings = name
	get_my_settings()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func get_my_settings():
	var saved_setting = Settings.get(my_settings)
	if saved_setting != null:
		#button_pressed = saved_setting
		value = saved_setting
		
		
	else:
		print("This doesnt have a saved setting: ", my_settings)


func save_my_settings(save_not_get):
	if save_not_get:
		#print("saved!")
		Settings.set(my_settings, value)
	else:
		#print("gotten!")
		get_my_settings()


func _on_drag_ended(value_changed: bool) -> void:
	print("yup er aditting")
	if my_settings == "general_audio":
		AudioServer.set_bus_volume_linear(Settings.general_bus, value)
	elif my_settings == "music_audio":
		AudioServer.set_bus_volume_linear(Settings.music_bus, value)
	elif my_settings == "sfx_audio":
		AudioServer.set_bus_volume_linear(Settings.sfx_bus, value)
	elif my_settings == "death_audio":
		AudioServer.set_bus_volume_linear(Settings.death_bus, value)
	elif my_settings == "pellet_audio":
		AudioServer.set_bus_volume_linear(Settings.pellet_bus, value)
	else:
		return
	
	for child in get_children():
		if child.is_in_group("slider_audio"):
			child.play()
