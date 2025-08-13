extends Node

#jeg tror jeg lagrer til settings så jeg kanskje kan ha flere filer for savefiles men ha samme settings, for nå
var save_path = "user://settings.save"


var locked_cursor = true

var touch_mode = false
# Called when the node enters the scene tree for the first time.
func _ready():
	# dette burde ikke være her når vi er ferdig! AAAAAAAAAAAA
	save_settings()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func save_settings():
	# dette er hvordan jeg lagrer til settings
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(locked_cursor)
	print("###########HOOOOOOOOOOOOOOOO saved this setting i think! #####################")
