extends Area2D

@onready var sploot_particle = $SplootParticle

# Called when the node enters the scene tree for the first time.
func _ready():
	bobble_animation()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	queue_free()
	var chicks = get_tree().get_nodes_in_group("ex_chocks")
	if chicks.size() == 1:
		Events.activate_ender()
	
	remove_child(sploot_particle)
	get_parent().add_child(sploot_particle)
	sploot_particle.emitting = true
	sploot_particle.global_position = global_position

func bobble_animation():
	#print("oop")
	var tween = create_tween()
	tween.tween_property($Sprite2D, "position", $Sprite2D.position + Vector2(0, 5), 1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($Sprite2D, "position", $Sprite2D.position + Vector2(0, 0), 1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	bobble_animation()
