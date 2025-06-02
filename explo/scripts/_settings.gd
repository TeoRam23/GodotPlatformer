extends Node

var locked_cursor = false
var save_path = "user://settings.save" # HEI jeg vet ikke om jeg burde lagre til settings eller hovedfilen
# Called when the node enters the scene tree for the first time.
func _ready():
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
