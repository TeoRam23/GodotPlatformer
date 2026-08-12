extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var sploot_particle = $SplootParticle
@onready var audio_collect: AudioStreamPlayer = $AudioCollect
var ye_am_done = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var stage = get_tree().current_scene.name
	var world_number = int(stage.split()[0])
	
	if world_number == 5:
		sprite_2d.visible = false
		sprite_2d = $SpriteMush
		sprite_2d.visible = true
		
		sploot_particle.color = Color(0.49, 0.443, 0.349)
	
	
	bobble_animation()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	ye_am_done = true
	queue_free()
	
	var chicks = get_tree().get_nodes_in_group("ex_chocks")
	var we_done = true
	for chi in chicks:
		if !chi.ye_am_done:
			we_done = false
			break
	
	if we_done:
		Events.activate_ender()
	#if chicks.size() == 1:
		#Events.activate_ender()
	
	audio_collect.playing = true
	audio_collect.reparent(get_parent())
	
	remove_child(sploot_particle)
	get_parent().add_child(sploot_particle)
	sploot_particle.global_position = global_position
	sploot_particle.emitting = true


func bobble_animation():
	#print("oop")
	var tween = create_tween()
	tween.tween_property(sprite_2d, "position", sprite_2d.position + Vector2(0, 5), 1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(sprite_2d, "position", sprite_2d.position + Vector2(0, 0), 1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	bobble_animation()
