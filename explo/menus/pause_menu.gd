extends CanvasLayer

var title = "default"

@onready var number_label = $PauseControl/NumberLabel
@onready var level_title = $PauseControl/LevelTitle


@onready var continue_butt = $PauseControl/VBoxContainer/Continue
@onready var back_to_hub_butt = $PauseControl/VBoxContainer/BackToHub
@onready var main_menu_butt = $PauseControl/VBoxContainer/MainMenu

const jeffrey_theme = preload("uid://cfuoqyle7q3jc")
const johnny_theme = preload("uid://cci7qdm1rnxr4")

var i_am_paused = false

#var hubby = preload("res://levels/hub.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	number_label.text = "Level " + get_tree().current_scene.name
	Events.pls_share_title.connect(update_title)
	Events.pls_swap_character.connect(johnnify)
	
	johnnify()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass


func _on_continue_pressed():
	#print("buttbutt")
	un_pause()

func _input(event):
	if (event.is_action_pressed("back") or event.is_action_pressed("cancel")) and get_tree().paused and i_am_paused:
		#print("na")
		un_pause()
		
	#if Input.is_action_just_pressed("musR"):
		#VariableManager.johnny_mode = !VariableManager.johnny_mode
		#johnnify()

func un_pause():
	i_am_paused = false
	#print("yup")
	get_tree().paused = false
	if get_parent().has_method("un_pause"):
		get_parent().un_pause()
		

func update_title(nytitle):
	#title = nytitle
	level_title.text = nytitle



func _on_restart_pressed():
	Events.general_leaving()
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_back_to_hub_pressed():
	VariableManager.current_title_time = 3
	Events.general_leaving()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://levels/hub.tscn")
	#get_tree().change_scene_to_packed(hubby)


func _on_main_menu_pressed():
	VariableManager.current_title_time = 3
	Events.general_leaving()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://explo/menus/start_screen.tscn")
	


func johnnify():
	if VariableManager.character_id == 0:
		#number_label.add_theme_color_override("font_color", Color(0.722, 0.29, 0.29)) # for pause theme 1
		number_label.add_theme_color_override("font_color", Color(0.78, 0.09, 0.239)) # for pause theme 2
		continue_butt.theme = jeffrey_theme
		main_menu_butt.theme = jeffrey_theme
		back_to_hub_butt.theme = jeffrey_theme
	elif VariableManager.character_id == 1:
		number_label.add_theme_color_override("font_color", Color(0.263, 0.482, 0.851))
		continue_butt.theme = johnny_theme
		main_menu_butt.theme = johnny_theme
		back_to_hub_butt.theme = johnny_theme
	
