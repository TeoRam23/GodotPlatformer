extends Area2D

#@export var world_select: PackedScene
@export var worl: String
var WORLY

@onready var animated_sprite_2d = $AnimatedSprite2D

const some_particles = preload("res://explo/scenes/poof_level_animation.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	if worl:
		WORLY = load(worl).instantiate()
		add_child(WORLY)
		WORLY.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if worl:
		if event.is_action_pressed("start") and get_overlapping_bodies():
			show_selection()
		elif event.is_action_pressed("back"):
			hide_selection()


func show_selection():
	if get_tree().paused: return
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Input.warp_mouse(get_window().size * 0.5)
	WORLY.visible = true
func hide_selection():
	#get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	WORLY.visible = false
	Input.warp_mouse(get_window().size * 0.5)


func _on_animated_sprite_2d_animation_looped():
	animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h
