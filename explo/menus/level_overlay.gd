extends CanvasLayer

@onready var death_label = $MarginContainer/VBoxContainer/DeathContainer/DeathLabel
@onready var johnny_label = $MarginContainer/VBoxContainer/OtherContainer/JohnnyContainer/JohnnyLabel

@onready var all_time_label = $MarginContainer/VBoxContainer/AllTimeControl/AllTimeLabel
@onready var time_label = $MarginContainer/VBoxContainer/TimeControl/TimeLabel

@onready var other_container = $MarginContainer/VBoxContainer/OtherContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.pls_player_died.connect(update_deaths)
	Events.pls_johnny_collected.connect(update_johnny)
	update_deaths()



func update_deaths():
	death_label.text = "x " + str(VariableManager.deaths)
	print(VariableManager.deaths)
	
func update_johnny():
	johnny_label.text = "x " + str(VariableManager.johnnies)
	

func show_rest(toggle):
	other_container.visible = toggle
