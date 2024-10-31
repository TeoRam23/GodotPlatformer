extends Area2D

@onready var collision_shape_2d = $CollisionShape2D
@onready var sprite_2d = $Sprite2D
@onready var swirl_sprite = $SwirlSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	check_for_chicks()
	Events.pls_activate_ender.connect(i_will_activate)
	#Events.level_completed.connect(animate_end)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_body_entered(body):
	Events.level_completed.emit()

func check_for_chicks():
	var chicks = get_tree().get_nodes_in_group("ex_chocks")
	if chicks.size() > 0:
		collision_shape_2d.set_deferred("disabled", true)
		swirl_sprite.modulate = Color(0.4, 0.4, 0.4)
		#sprite_2d.modulate = Color(0.55, 0.55, 0.55)

func i_will_activate():
	print("I did it!")
	collision_shape_2d.set_deferred("disabled", false)
	#sprite_2d.modulate = Color(0.74, 0.547, 0.34)
	swirl_sprite.modulate = Color(1, 1, 1)


func _on_swirl_sprite_animation_looped():
	swirl_sprite.flip_h = !swirl_sprite.flip_h
	
# Dette var for å gjøre slutten lysere på slutten
func animate_end():
	swirl_sprite.modulate = Color(1, 1, 1, 0.816)
	
