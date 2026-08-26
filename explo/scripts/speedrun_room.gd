extends Node2D

@onready var any_timer: Label = $AnyPanel/AnyTimer
@onready var any_death_label: Label = $AnyPanel/AnyDeathContainer/AnyDeathLabel
@onready var all_levels_label: Label = $AllLevelsPanel/AllLevelsLabel
@onready var all_levels_timer: Label = $AllLevelsPanel/AllLevelsTimer
@onready var all_death_texture: TextureRect = $AllLevelsPanel/AllDeathContainer/AllDeathTexture
@onready var all_death_label: Label = $AllLevelsPanel/AllDeathContainer/AllDeathLabel

@onready var all_levels_panel: Panel = $AllLevelsPanel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if VariableManager.end_time != 0.0:
		any_timer.text = convert_time(VariableManager.end_time)
		any_death_label.text = "x " + str(VariableManager.end_deaths)
	if VariableManager.all_levels_time != 0.0:
		all_levels_timer.text = convert_time(VariableManager.all_levels_time)
		all_death_label.text = "x " + str(VariableManager.all_levels_deaths)
		
		all_levels_label.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))
		all_levels_timer.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))
		all_death_label.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))
		all_death_texture.modulate = Color(1.0, 1.0, 1.0)
		
		all_levels_panel
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


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
