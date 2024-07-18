extends Node2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var poof_particle = $PoofParticle

var activate = false
var parent : CharacterBody2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if parent:
		if parent.has_method("is_on_floor"):
			if parent.is_on_floor():
				parent.movement_data = parent.main_data
				remove_child(poof_particle)
				get_tree().root.add_child(poof_particle)
				poof_particle.global_position = global_position
				poof_particle.emitting = true
				
				queue_free()
	var input_axis = Input.get_axis("left", "right")
	if input_axis != 0:
		animated_sprite.flip_h = (input_axis > 0)


func glide_parent():
	parent = get_parent()
	parent.movement_data = load("res://data/GlidingMovementData.tres")
