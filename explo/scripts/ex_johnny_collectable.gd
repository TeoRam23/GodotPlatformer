extends Area2D

@onready var sploot_particle = $SplootParticle
@onready var animated_sprite = $AnimatedSprite2D
@onready var fire_sprite = $FireSprite
@onready var johnny_tiny_sprite = $JohnnyTinySprite
@onready var collision_shape_box = $CollisionShapeBox
@onready var audio_johnny_get: AudioStreamPlayer = $AudioJohnnyGet
@onready var audio_collect: AudioStreamPlayer = $AudioCollect

var im_taken = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var this_level = VariableManager.find_level(get_tree().current_scene.name)
	if this_level:
		if this_level.johnny_collected:
			disable_me()
	#print("I FOUND THIS, JOHNNY! ME! FOUND THIS! ", this_level)
	if Settings.zero_gravity:
		collision_shape_box.disabled = true
		visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	#print("look im shouldnt be here")
	if not im_taken:
		Events.johnny_collected()
	
	audio_johnny_get.playing = true
	audio_johnny_get.reparent(get_parent())
	audio_collect.playing = true
	audio_collect.reparent(get_parent())
	
	remove_child(sploot_particle)
	get_parent().add_child(sploot_particle)
	sploot_particle.global_position = global_position
	sploot_particle.emitting = true
	
	
	queue_free()

func disable_me():
	im_taken = true
	# Erstatt dette med hvordan enn jeg johnny skal se ut her
	fire_sprite.modulate = Color(0.5, 0.5, 0.5)
	johnny_tiny_sprite.modulate = Color(0.5, 0.5, 0.5)
	johnny_tiny_sprite.play("sit")
	sploot_particle.modulate = Color(0.5, 0.5, 0.5)
