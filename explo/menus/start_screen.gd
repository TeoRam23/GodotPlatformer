extends Node2D

@onready var credits_canvas = $CreditsCanvas
@onready var settings_menu = $SettingsMenu

const HUB = preload("res://levels/hub.tscn")

var current_open_screen = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.pls_save_settings_yall.connect(settings_closed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_start_pressed():
	get_tree().paused = false
	#get_tree().change_scene_to_file("res://levels/hub.tscn")
	get_tree().change_scene_to_packed(HUB)


func _on_button_settings_pressed():
	if !current_open_screen:
		settings_menu.visible = true
		current_open_screen = "settings"


func _on_button_credits_pressed():
	if !current_open_screen:
		credits_canvas.visible = true
		current_open_screen = "credits"
	


func _on_button_quit_pressed():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
	
func settings_closed(save_not_get):
	if current_open_screen == "settings":
		current_open_screen = ""
	

func _input(event):
	if Input.is_action_just_pressed("back"):
		if current_open_screen == "credits":
			credits_canvas.visible = false
			current_open_screen = ""
		if current_open_screen == "settings":
			current_open_screen = ""
			# tror settings i seg selv behandler lukking, siden den må lagre masse greier
