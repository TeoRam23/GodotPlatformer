extends Control

@onready var grid_container = $GridContainer
@onready var level_title = $"../LevelTitle"
@onready var best_time_label = $"../BestTimeLabel"

# Called when the node enters the scene tree for the first time.
func _ready():
	var buttons = grid_container.get_children()
	#print(buttons)
	for butt in buttons:
		if butt.is_in_group("level_button_group"):
			butt.label = level_title
			butt.time_label = best_time_label


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass



#func _on_back_button_pressed():
	#get_parent().get_parent().hide_selection()
