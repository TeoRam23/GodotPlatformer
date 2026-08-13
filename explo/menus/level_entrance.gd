extends Area2D

#@export var world_select: PackedScene
@export var worl: String
@export var world_5 = false
var WORLY
var is_active = false
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var sprite_mushroom: Sprite2D = $SpriteMushroom

const some_particles = preload("res://explo/scenes/poof_level_animation.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	if worl:
		WORLY = load(worl).instantiate()
		add_child(WORLY)
		WORLY.visible = false
	
	if world_5:
		sprite_2d.visible = false
		sprite_mushroom.visible = true
		animated_sprite_2d.visible = false
		animated_sprite_2d = $AnimatedSpriteMushroom
		animated_sprite_2d.visible = true
		



func _input(event):
	if worl:
		if event.is_action_pressed("start") and get_overlapping_bodies():
			show_selection()
		elif is_active:
			if event.is_action_pressed("back"):
				hide_selection()
			elif event.is_action_pressed("cancel"):
				print("this is running fsr")
				hide_selection()


func show_selection():
	if get_tree().paused: return
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Input.warp_mouse(get_window().size * 0.5)
	WORLY.visible = true
	VariableManager.set_deferred("pausing_disabled", true)
	is_active = true
	
func hide_selection():
	print("hiding selection")
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	WORLY.visible = false
	Input.warp_mouse(get_window().size * 0.5)
	VariableManager.set_deferred("pausing_disabled", false)
	is_active = false

func disable_me():
	animated_sprite_2d.visible = false
	collision_shape_2d.disabled = true


func _on_animated_sprite_2d_animation_looped():
	animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h
