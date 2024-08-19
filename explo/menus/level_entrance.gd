extends Area2D

@export var world_select: PackedScene
@export var worl: String
var WORLY

@onready var animated_sprite_2d = $AnimatedSprite2D

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
			get_tree().paused = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			Input.warp_mouse(get_window().size * 0.5)
			WORLY.visible = true
		elif event.is_action_pressed("back"):
			get_tree().paused = false
			Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
			WORLY.visible = false


func _on_animated_sprite_2d_animation_looped():
	animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h
