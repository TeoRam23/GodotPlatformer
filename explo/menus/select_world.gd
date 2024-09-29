extends Control

@onready var grid_container = $GridContainer

# Called when the node enters the scene tree for the first time.
#func _ready():
	#var buttn = grid_container.get_children()[0]
	#buttn.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass



func _on_back_button_pressed():
	get_parent().get_parent().hide_selection()
