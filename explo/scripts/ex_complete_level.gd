extends Area2D

@onready var collision_shape_2d = $CollisionShape2D
@onready var sprite_2d = $Sprite2D
@onready var swirl_mask = $SwirlMask
@onready var swirl_sprite = $SwirlMask/SwirlSprite
@onready var audio_jingle: AudioStreamPlayer = $AudioJingle
@onready var audio_mushroom: AudioStreamPlayer = $AudioMushroom

var world_number = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	swirl_mask.frame = 7
	check_for_chicks()
	Events.pls_activate_ender.connect(i_will_activate)
	
	
	var stage = get_tree().current_scene.name
	world_number = int(stage.split()[0])
	swirl_sprite.material.set("shader_parameter/parent_id", world_number)
	#Events.level_completed.connect(animate_end)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_body_entered(body):
	if world_number == 5:
		audio_mushroom.play()
	else:
		audio_jingle.play()
	Events.level_completed.emit()

func check_for_chicks():
	var chicks = get_tree().get_nodes_in_group("ex_chocks")
	if chicks.size() > 0:
		collision_shape_2d.set_deferred("disabled", true)
		#swirl_sprite.modulate = Color(0.4, 0.4, 0.4)
		
		#swirl_sprite.visible = false
		swirl_mask.frame = 0
		#sprite_2d.modulate = Color(0.55, 0.55, 0.55)

func i_will_activate():
	print("I did it!")
	collision_shape_2d.set_deferred("disabled", false)
	#swirl_sprite.modulate = Color(1, 1, 1)
	
	#swirl_sprite.visible = true
	swirl_mask.play()
	#sprite_2d.modulate = Color(0.74, 0.547, 0.34)


func _on_swirl_sprite_animation_looped():
	swirl_sprite.flip_h = !swirl_sprite.flip_h
	
# Dette var for å gjøre slutten lysere på slutten
func animate_end():
	swirl_sprite.modulate = Color(1, 1, 1, 0.816)
	
