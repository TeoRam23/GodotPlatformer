extends CanvasLayer

var changes_made = false


var locked_cursor = false
#@onready var butt_locked_cursor = $ButtLockedCursor
#@onready var butt_locked_cursor = $VBoxContainer/ButtLockedCursor
#@onready var butt_locked_cursor = $ScrollGameplay/BoxGameplay/BoxMouseSettings/ButtLockedCursor

@onready var sure_control = $SureControl


@onready var butt_video = $ButtVideo
@onready var butt_audio = $ButtAudio
@onready var butt_gameplay = $ButtGameplay
@onready var butt_controls = $ButtControls


@onready var scroll_video = $ScrollVideo
@onready var scroll_audio = $ScrollAudio
@onready var scroll_gameplay = $ScrollGameplay
@onready var scroll_controls = $ScrollControls

# Called when the node enters the scene tree for the first time.
func _ready():
	get_saved_settings() # denne tenker jeg å kutte ut og erstatte med script i selve knappen
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func send_settings():
	pass


func get_saved_settings():
	# okay, vi må gjøre dette ferdig. sammen. men jeg skal ikke gjøre noe mer, det er kun du og kanskje fremtidige deg-er
	# men sånn, jeg må finne ut hvordan strukturen til settings i saved fil skal være
	#butt_locked_cursor.button_pressed = Settings.locked_cursor
	pass
	

	
func _input(event):
	if Input.is_action_just_pressed("back"):
		save_settings()
		close_screen()
		#if changes_made == true:
			#sure_control.visible = true
		#else:
			#visible = false
		#
	#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		#changes_made = true
		# dette er kanskje ikke en bra løsning, se litt på det senere PLIS
		


func save_settings():
	Events.save_settings_yall(true)
	Settings.call_deferred("save_settings")
	
	#Settings.locked_cursor = butt_locked_cursor.is_pressed()
	pass


func _on_butt_save_pressed():
	save_settings()
	close_screen()
	#if changes_made == true:
		#sure_control.visible = true
	#else:
		#visible = false

func close_screen():
	Events.save_settings_yall(false)
	
	visible = false
	_on_butt_video_pressed()
	
	#var par = get_parent()
	#if par.is_in_group("StartScreen"):
		#par.current_open_screen = ""


func _on_sure_yes_button_pressed(tog):
	save_settings()
	sure_control.visible = false
	visible = false


func _on_sure_no_button_pressed(tog):
	sure_control.visible = false
	visible = false


func _on_sure_ex_button_pressed():
	sure_control.visible = false



func put_tabs_correct(on_button):
	butt_video.button_pressed = false
	butt_audio.button_pressed = false
	butt_gameplay.button_pressed = false
	butt_controls.button_pressed = false
	on_button.button_pressed = true


func _on_butt_video_pressed():
	put_tabs_correct(butt_video)
	scroll_video.visible = true
	scroll_audio.visible = false
	scroll_gameplay.visible = false
	scroll_controls.visible = false

func _on_butt_audio_pressed():
	put_tabs_correct(butt_audio)
	scroll_video.visible = false
	scroll_audio.visible = true
	scroll_gameplay.visible = false
	scroll_controls.visible = false

func _on_butt_gameplay_pressed():
	put_tabs_correct(butt_gameplay)
	scroll_video.visible = false
	scroll_audio.visible = false
	scroll_gameplay.visible = true
	scroll_controls.visible = false

func _on_butt_controls_pressed():
	put_tabs_correct(butt_controls)
	scroll_video.visible = false
	scroll_audio.visible = false
	scroll_gameplay.visible = false
	scroll_controls.visible = true

