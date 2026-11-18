extends Node2D

@onready var credits_canvas = $CreditsCanvas
@onready var settings_menu = $SettingsMenu

@onready var main_control: Control = $MainCanvas/Control
@onready var saves_control: Control = $SavesCanvas/SavesControl
@onready var savefile_box: HBoxContainer = $SavesCanvas/SavesControl/SavefileBox
@onready var confirm_box: VBoxContainer = $SavesCanvas/SavesControl/ConfirmBox
@onready var delete_control: Control = $SavesCanvas/SavesControl/DeleteControl
@onready var copy_control: Control = $SavesCanvas/SavesControl/CopyControl
@onready var v_box_container: VBoxContainer = $MainCanvas/Control/VBoxContainer
@onready var start_art: Sprite2D = $MainCanvas/Control/StartArt
@onready var button_continue: Button = $SavesCanvas/SavesControl/ConfirmBox/ButtonContinue
@onready var cop_del_box: HBoxContainer = $SavesCanvas/SavesControl/ConfirmBox/CopDelBox
@onready var button_delete: Button = $SavesCanvas/SavesControl/ConfirmBox/CopDelBox/ButtonDelete
@onready var button_copy: Button = $SavesCanvas/SavesControl/ConfirmBox/CopDelBox/ButtonCopy
@onready var copy_label: Label = $SavesCanvas/SavesControl/CopyControl/CopyPanel/CopyLabel
@onready var savefile_arrow: Sprite2D = $SavesCanvas/SavesControl/SavefileBox/SavefileArrow

@onready var time_label_1: Label = $SavesCanvas/SavesControl/SavefileBox/Savefile1/TimeLabel1
@onready var deaths_label_1: Label = $SavesCanvas/SavesControl/SavefileBox/Savefile1/DeathsLabel1
@onready var time_label_2: Label = $SavesCanvas/SavesControl/SavefileBox/Savefile2/TimeLabel2
@onready var deaths_label_2: Label = $SavesCanvas/SavesControl/SavefileBox/Savefile2/DeathsLabel2
@onready var time_label_3: Label = $SavesCanvas/SavesControl/SavefileBox/Savefile3/TimeLabel3
@onready var deaths_label_3: Label = $SavesCanvas/SavesControl/SavefileBox/Savefile3/DeathsLabel3

const HUB = preload("res://levels/hub.tscn")
var credits = load("res://explo/menus/credits_scroll.tscn")

var current_open_screen = ""

var gonna_copy = false
var copying_file = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.pls_save_settings_yall.connect(settings_closed)
	setup_times_and_deaths()
	
	saves_control.visible = false
	saves_control.modulate.a = 0
	confirm_box.visible = false
	confirm_box.modulate.a = 0


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
	#main_control.propagate_call("set_behaviour_recursive")
	
	await tween.finished
	
	var tween2 = get_tree().create_tween()
	saves_control.visible = true
	tween2.tween_property(saves_control, "modulate:a", 1, 0.3)
	saves_control.propagate_call("set_mouse_filter", [Control.MOUSE_FILTER_STOP])
	
	current_open_screen = "saves"

func hide_saves_menu():
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(start_art, "position:y", 180.0, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(start_art, "modulate:a", 1, 0.5)
	tween.tween_property(v_box_container, "position:x", 60.0, 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(saves_control, "modulate:a", 0, 0.3)
	saves_control.propagate_call("set_mouse_filter", [Control.MOUSE_FILTER_IGNORE])
	await tween.finished
	main_control.propagate_call("set_mouse_filter", [Control.MOUSE_FILTER_STOP])
	saves_control.visible = false
	

func show_confirm_buttons():
	if VariableManager.get_savefile_info(VariableManager.save_file_used)[0] == 0.0:
		button_continue.text = "Start new file"
		cop_del_box.visible = false
	else:
		button_continue.text = "Continue"
		cop_del_box.visible = true
		
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(savefile_box, "position:y", 20.0, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	confirm_box.visible = true
	tween.tween_property(confirm_box, "modulate:a", 1, 0.3)
	current_open_screen = "confirm"
	

func hide_confirm_buttons():
	savefile_arrow.visible = false
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(savefile_box, "position:y", 60.0, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(confirm_box, "modulate:a", 0, 0.3)
	current_open_screen = "saves"
	await tween.finished
	confirm_box.visible = true


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
		elif current_open_screen == "saves":
			current_open_screen = ""
			hide_saves_menu()
		elif current_open_screen == "confirm":
			hide_confirm_buttons()
		elif current_open_screen == "delete":
			current_open_screen = "confirm"
			delete_control.visible = false
		elif current_open_screen == "copy":
			current_open_screen = "confirm"
			copy_control.visible = false


func _on_savefile_1_pressed() -> void:
	if gonna_copy and VariableManager.save_file_used != 1:
		copying_file = 1
		show_copy_control()
		return
	VariableManager.save_file_used = 1
	savefile_arrow.position.x = 74.0
	savefile_arrow.visible = true
	show_confirm_buttons()

func _on_savefile_2_pressed() -> void:
	if gonna_copy and VariableManager.save_file_used != 2:
		copying_file = 2
		show_copy_control()
		return
	VariableManager.save_file_used = 2
	savefile_arrow.position.x = 225.0
	savefile_arrow.visible = true
	show_confirm_buttons()

func _on_savefile_3_pressed() -> void:
	if gonna_copy and VariableManager.save_file_used != 3:
		copying_file = 3
		show_copy_control()
		return
	VariableManager.save_file_used = 3
	savefile_arrow.position.x = 375.0
	savefile_arrow.visible = true
	show_confirm_buttons()

	

func setup_times_and_deaths():
	var td_1 = VariableManager.get_savefile_info(1)
	if td_1[0] == 0.0:
		time_label_1.visible = false
		deaths_label_1.visible = false
	else:
		time_label_1.text = "Time: " + convert_time(td_1[0])
		deaths_label_1.text = "Deaths: " + str(td_1[1])
		time_label_1.visible = true
		deaths_label_1.visible = true
	var td_2 = VariableManager.get_savefile_info(2)
	if td_2[0] == 0.0:
		time_label_2.visible = false
		deaths_label_2.visible = false
	else:
		time_label_2.text = "Time: " + convert_time(td_2[0])
		deaths_label_2.text = "Deaths: " + str(td_2[1])
		time_label_2.visible = true
		deaths_label_2.visible = true
	var td_3 = VariableManager.get_savefile_info(3)
	if td_3[0] == 0.0:
		time_label_3.visible = false
		deaths_label_3.visible = false
	else:
		time_label_3.text = "Time: " + convert_time(td_3[0])
		deaths_label_3.text = "Deaths: " + str(td_3[1])
		time_label_3.visible = true
		deaths_label_3.visible = true


func convert_time(the_time: float) -> String:
	var show_time = snappedf(the_time, 0.01666666666667)
	var minutes = int(floor(show_time * 0.01666666666667)) % 60
	var hours = int(floor(show_time / 3600))
	var seconds = int(show_time) % 60
	var millis = (show_time - floor(show_time)) * 1000
	var time_text = "%02d:%02d.%03d" % [minutes, seconds, millis]
	if hours:
		time_text = str(hours)+":" + time_text
	return str(time_text)


func _on_button_continue_pressed() -> void:
	await VariableManager.load_variables()
	go_to_hub()

func _on_button_delete_pressed() -> void:
	delete_control.visible = true
	current_open_screen = "delete"
	button_copy.button_pressed = false
	gonna_copy = false

func _on_button_copy_pressed() -> void:
	print("copy that, over")
	if button_copy.button_pressed:
		gonna_copy = true
	else:
		gonna_copy = false
	



func _on_button_yes_delete_pressed() -> void:
	current_open_screen = "confirm"
	delete_control.visible = false
	VariableManager.delete_savefile(VariableManager.save_file_used)
	setup_times_and_deaths()
	show_confirm_buttons()

func _on_button_no_delete_pressed() -> void:
	current_open_screen = "confirm"
	delete_control.visible = false



func show_copy_control():
	copy_label.text = "Are you sure you want to copy data from Savefile "+str(VariableManager.save_file_used)+" over to Savefile "+str(copying_file)+"?"
	current_open_screen = "copy"
	copy_control.visible = true
	gonna_copy = false

func _on_button_copy_yes_pressed() -> void:
	current_open_screen = "confirm"
	copy_control.visible = false
	button_copy.button_pressed = false
	VariableManager.copy_savefile(VariableManager.save_file_used, copying_file)
	if VariableManager.save_file_used == 1:
		savefile_arrow.position.x = 74.0
	elif VariableManager.save_file_used == 2:
		savefile_arrow.position.x = 225.0
	elif VariableManager.save_file_used == 3:
		savefile_arrow.position.x = 375.0
	gonna_copy = false
	setup_times_and_deaths()
	show_confirm_buttons()


func _on_button_copy_no_pressed() -> void:
	current_open_screen = "confirm"
	copy_control.visible = false
	button_copy.button_pressed = false
