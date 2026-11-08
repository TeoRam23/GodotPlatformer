extends Node2D

@onready var spacebar_icon: Sprite2D = $SpacebarIcon
var spacebar_position := 0.0
var tween_time := 0.3

func _ready() -> void:
	spacebar_position = spacebar_icon.position.y
	

func show_icon():
	if not is_inside_tree():
		return
	var tween = get_tree().create_tween().set_parallel(true)
	spacebar_icon.position.y = -3.0
	tween.tween_property(spacebar_icon,"position:y", spacebar_position, tween_time)
	tween.tween_property(spacebar_icon,"modulate:a", 1, tween_time)
	

func hide_icon():
	# checks tree because when player stands on the area and closes the game, it gives an error about cant call method on a null value
	if not is_inside_tree():
		return
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(spacebar_icon,"position:y", -3.0, tween_time)
	tween.tween_property(spacebar_icon,"modulate:a", 0, tween_time)
		
