extends Area2D

@onready var johnny_npc_collision: CollisionShape2D = $JohnnyNpcCollision

@onready var johnny_get_animation: AnimatedSprite2D = $JohnnyGetAnimation
@onready var johnny_get_sprite: Sprite2D = $JohnnyGetSprite

@onready var johnny_play_sprite: Sprite2D = $JohnnyPlaySprite


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if VariableManager.johnny_activated == true:
		set_up_johnny_npc()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("start"):
		if get_overlapping_bodies():
			if !VariableManager.johnny_activated:
				activate_johnny()
			else:
				pass #når man skal bytte med johnny

func activate_johnny():
	johnny_get_animation.visible = true
	johnny_get_animation.play("default")
	print("lets john this comic!")
	

func _on_johnny_get_animation_animation_finished() -> void:
	VariableManager.johnny_activated = true
	#VariableManager.save_variables()
	set_up_johnny_npc()


func set_up_johnny_npc():
	johnny_get_animation.visible = false
	johnny_get_sprite.visible = false
	johnny_play_sprite.visible = true
	johnny_npc_collision.position.x = 16.0 # plassen der den går over play johnny
