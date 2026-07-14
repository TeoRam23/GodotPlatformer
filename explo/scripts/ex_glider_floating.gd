extends Area2D

@onready var ex_glider_child = $ExGliderChild
@onready var bub_poof = $BubPoof

@onready var collision_shape = $CollisionShape2D
@onready var sprite = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	bobble_animation()
	var stage = get_tree().current_scene.name
	var world_number = int(stage.split()[0])
	material.set("shader_parameter/parent_id", world_number)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	#print("doin it twice?")
	remove_child(ex_glider_child)
	body.add_child(ex_glider_child)
	ex_glider_child.glide_parent()
	
	#remove_child(bub_poof)
	#get_tree().root.add_child(bub_poof)
	#bub_poof.global_position = global_position
	bub_poof.emitting = true
	
	collision_shape.set_deferred("disabled", true)
	sprite.visible = false
	#queue_free()

func reemerge():
	collision_shape.set_deferred("disabled", false)
	sprite.visible = true

func bobble_animation():
	#print("oop")
	var tween = create_tween()
	tween.tween_property($Sprite2D, "position", $Sprite2D.position + Vector2(0, 4), 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property($Sprite2D, "position", $Sprite2D.position + Vector2(0, 0), 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await tween.finished
	bobble_animation()
