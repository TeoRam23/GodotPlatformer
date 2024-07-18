extends Area2D

@onready var ex_glider_child = $ExGliderChild
@onready var bub_poof = $BubPoof

# Called when the node enters the scene tree for the first time.
func _ready():
	bobble_animation()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	remove_child(ex_glider_child)
	body.add_child(ex_glider_child)
	ex_glider_child.glide_parent()
	ex_glider_child.visible = true
	
	remove_child(bub_poof)
	get_tree().root.add_child(bub_poof)
	bub_poof.global_position = global_position
	bub_poof.emitting = true
	
	queue_free()


func bobble_animation():
	#print("oop")
	var tween = create_tween()
	tween.tween_property($Sprite2D, "position", $Sprite2D.position + Vector2(0, 5), 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property($Sprite2D, "position", $Sprite2D.position + Vector2(0, 0), 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await tween.finished
	bobble_animation()
