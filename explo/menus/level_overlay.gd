extends CanvasLayer

@onready var death_label = $MarginContainer/VBoxContainer/HBoxContainer/DeathLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.pls_player_died.connect(update_deaths)
	update_deaths()
	pass # Replace with function body.



func update_deaths():
	death_label.text = "x " + str(VariableManager.deaths)
	print(VariableManager.deaths)
	
