extends CanvasLayer

var locked_cursor = false
@onready var butt_locked_cursor = $ButtLockedCursor

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func send_settings():
	pass


func _on_butt_save_pressed():
	if butt_locked_cursor.is_pressed():
		Settings.locked_cursor = butt_locked_cursor.is_pressed()
		

func get_saved_settings():
	# okay, vi må gjøre dette ferdig. sammen. men jeg skal ikke gjøre noe mer, det er kun du og kanskje fremtidige deg-er
	# men sånn, jeg må finne ut hvordan strukturen til settings i saved fil skal være
	butt_locked_cursor.button_pressed = Settings.locked_cursor
