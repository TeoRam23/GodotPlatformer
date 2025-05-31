extends Node2D

@onready var credits_canvas = $CreditsCanvas
const HUB = preload("res://levels/hub.tscn")

var current_open_screen = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_start_pressed():
	get_tree().paused = false
	#get_tree().change_scene_to_file("res://levels/hub.tscn")
	get_tree().change_scene_to_packed(HUB)


func _on_button_credits_pressed():
	credits_canvas.visible = true
	current_open_screen = "credits"
	


func _on_button_quit_pressed():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()

func _input(event):
	if Input.is_action_just_pressed("back"):
		if current_open_screen == "credits":
			credits_canvas.visible = false
			current_open_screen = ""

