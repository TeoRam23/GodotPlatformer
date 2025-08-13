extends CheckButton

var my_settings: String

# Called when the node enters the scene tree for the first time.
func _ready():
	#Events.connect("save_my_settings", pls_save)
	Events.pls_save_settings_yall.connect(save_my_settings)
	
	my_settings = name
	var saved_setting = Settings.get(my_settings)
	button_pressed = saved_setting


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func save_my_settings():
	Settings.set(my_settings, is_pressed())
