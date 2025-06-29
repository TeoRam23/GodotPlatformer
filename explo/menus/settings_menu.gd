extends CanvasLayer

var changes_made = false


var locked_cursor = false
#@onready var butt_locked_cursor = $ButtLockedCursor
#@onready var butt_locked_cursor = $VBoxContainer/ButtLockedCursor
@onready var butt_locked_cursor = $ScrollGameplay/BoxGameplay/BoxMouseSettings/ButtLockedCursor


@onready var sure_control = $SureControl

# Called when the node enters the scene tree for the first time.
func _ready():
	get_saved_settings()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func send_settings():
	pass


func _on_butt_save_pressed():
	save_settings()
		

func get_saved_settings():
	# okay, vi må gjøre dette ferdig. sammen. men jeg skal ikke gjøre noe mer, det er kun du og kanskje fremtidige deg-er
	# men sånn, jeg må finne ut hvordan strukturen til settings i saved fil skal være
	butt_locked_cursor.button_pressed = Settings.locked_cursor
	

func save_settings():
	Settings.locked_cursor = butt_locked_cursor.is_pressed()
	
	
func _input(event):
	if Input.is_action_just_pressed("back"):
		if changes_made == true:
			sure_control.visible = true
		else:
			visible = false
		
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		changes_made = true
		# dette er kanskje ikke en bra løsning, se litt på det senere PLIS
		


func _on_sure_yes_button_pressed():
	save_settings()
	sure_control.visible = false
	visible = false


func _on_sure_no_button_pressed():
	sure_control.visible = false
	visible = false


func _on_sure_ex_button_pressed():
	sure_control.visible = false
