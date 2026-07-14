extends Node2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var poof_particle = $PoofParticle

var activate = false
var parent : CharacterBody2D

var bubble : Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.pls_player_died.connect(poof_away)
	Events.level_completed.connect(poof_away)
	bubble = get_parent()
	var stage = get_tree().current_scene.name
	var world_number = int(stage.split()[0])
	material.set("shader_parameter/parent_id", world_number)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent() == parent:
		if parent.has_method("is_on_floor"):
			if parent.is_on_floor() or parent.is_disabled:
				poof_away()
	var input_axis = Input.get_axis("left", "right")
	if input_axis != 0:
		animated_sprite.flip_h = (input_axis > 0)


func glide_parent():
	parent = get_parent()
	parent.movement_data = load("res://data/GlidingMovementData.tres")
	if Settings.zero_gravity:
		parent.movement_data.gravity_scale = 0
	
	animated_sprite.visible = true


func poof_away():
	if get_parent() == parent:
		#print("ye did ti mate")
		parent.movement_data = parent.main_data
		
		var old_position = global_position
		animated_sprite.visible = false
		
		parent.remove_child(self)
		bubble.add_child(self)
		poof_particle.global_position = old_position
		poof_particle.emitting = true
		
		if bubble.has_method("reemerge"):
			bubble.reemerge()
