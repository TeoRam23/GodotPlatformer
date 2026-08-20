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
