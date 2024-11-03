extends CanvasLayer

@onready var death_label = $MarginContainer/VBoxContainer/DeathContainer/DeathLabel
@onready var johnny_label = $MarginContainer/VBoxContainer/OtherContainer/JohnnyContainer/JohnnyLabel

@onready var all_time_label = $MarginContainer/VBoxContainer/AllTimeControl/AllTimeLabel
@onready var time_label = $MarginContainer/VBoxContainer/TimeControl/TimeLabel

@onready var other_container = $MarginContainer/VBoxContainer/OtherContainer

@onready var level_title_box = $LevelTitleBox
@onready var level_title_label = $LevelTitleBox/LevelTitleLabel
@onready var title_timer = $LevelTitleBox/TitleTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.pls_player_died.connect(update_deaths)
	Events.pls_johnny_collected.connect(update_johnny)
	Events.pls_share_title.connect(update_title)
	Events.pls_resetting_level.connect(update_global_title_timer)
	
	update_deaths()
	update_johnny()
	
	var curtime = VariableManager.current_title_time
	if curtime != 0:
		level_title_box.visible = true
		title_timer.wait_time = curtime
		title_timer.start()



func update_deaths():
	death_label.text = "x " + str(VariableManager.deaths)
	print(VariableManager.deaths)
	
func update_johnny():
	johnny_label.text = "x " + str(VariableManager.johnnies)
	

func show_rest(toggle):
	other_container.visible = toggle

func update_title(nytitle):
	level_title_label.text = nytitle


func _on_timer_timeout():
	level_title_box.visible = false

func update_global_title_timer():
	print("HEAVE")
	VariableManager.current_title_time = title_timer.time_left
