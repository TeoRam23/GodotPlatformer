extends Node2D

@onready var credits_canvas = $CreditsCanvas
@onready var settings_menu = $SettingsMenu

@onready var main_control: Control = $MainCanvas/Control
@onready var saves_control: Control = $SavesCanvas/Control
@onready var v_box_container: VBoxContainer = $MainCanvas/Control/VBoxContainer
@onready var start_art: Sprite2D = $MainCanvas/Control/StartArt

const HUB = preload("res://levels/hub.tscn")
var credits = load("res://explo/menus/credits_scroll.tscn")

var current_open_screen = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.pls_save_settings_yall.connect(settings_closed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func go_to_hub():
	get_tree().paused = false
	#get_tree().change_scene_to_file("res://levels/hub.tscn")
	get_tree().change_scene_to_packed(HUB)


func _on_button_start_pressed():
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(start_art, "position:y", 270, 0.3)
	tween.tween_property(start_art, "modulate:a", 0, 0.3)
	tween.tween_property(v_box_container, "position:x", -400, 0.3)
	main_control.propagate_call("set_mouse_filter", [Control.MOUSE_FILTER_IGNORE])
	
	await tween.finished
	
	var tween2 = get_tree().create_tween()
	saves_control.visible = true
	tween2.tween_property(saves_control, "modulate:a", 1, 0.3)
	saves_control.propagate_call("set_mouse_filter", [Control.MOUSE_FILTER_STOP])
	
	current_open_screen = "saves"

func hide_saves_menu():
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(start_art, "position:y", 180.0, 0.3)
	tween.tween_property(start_art, "modulate:a", 1, 0.3)
	tween.tween_property(v_box_container, "position:x", 60.0, 0.3)
	main_control.propagate_call("set_mouse_filter", [Control.MOUSE_FILTER_STOP])
	
	tween.tween_property(saves_control, "modulate:a", 0, 0.3)
	saves_control.propagate_call("set_mouse_filter", [Control.MOUSE_FILTER_IGNORE])
	await tween.finished
	saves_control.visible = false
	


func _on_button_settings_pressed():
	if !current_open_screen:
		settings_menu.visible = true
		current_open_screen = "settings"


func _on_button_credits_pressed():
	#if !current_open_screen:
		#credits_canvas.visible = true
		#current_open_screen = "credits"
	get_tree().change_scene_to_packed(credits)
	


func _on_button_quit_pressed():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
	
func settings_closed(save_not_get):
	if current_open_screen == "settings":
		current_open_screen = ""
	

func _input(event):
	if Input.is_action_just_pressed("back") or Input.is_action_just_pressed("cancel"):
		if current_open_screen == "credits":
			credits_canvas.visible = false
			current_open_screen = ""
		if current_open_screen == "settings":
			current_open_screen = ""
			# tror settings i seg selv behandler lukking, siden den må lagre masse greier
		if current_open_screen == "saves":
			current_open_screen = ""
			hide_saves_menu()


func _on_savefile_1_pressed() -> void:
	VariableManager.save_file_used = 1
	await VariableManager.load_variables()
	go_to_hub()

func _on_savefile_2_pressed() -> void:
	VariableManager.save_file_used = 2
	await VariableManager.load_variables()
	go_to_hub()

func _on_savefile_3_pressed() -> void:
	VariableManager.save_file_used = 3
	await VariableManager.load_variables()
	go_to_hub()
