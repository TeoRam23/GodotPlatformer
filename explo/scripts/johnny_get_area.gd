extends Area2D

@onready var johnny_npc_collision: CollisionShape2D = $JohnnyNpcCollision

@onready var johnny_get_animation: AnimatedSprite2D = $JohnnyGetAnimation
@onready var johnny_get_sprite: Sprite2D = $JohnnyGetSprite
@onready var johnny_get_dialogue: CanvasLayer = $JohnnyGetDialogue

@onready var johnny_play_sprite: Sprite2D = $JohnnyPlaySprite
@onready var johnny_play_dialogue: CanvasLayer = $JohnnyPlayDialogue


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Events.pls_dialogue_finished.connect(swap_johnny)
	
	#VariableManager.johnny_activated = false
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
				play_johnny()

func activate_johnny():
	get_tree().paused = true
	VariableManager.pausing_disabled = true
	johnny_get_animation.visible = true
	johnny_get_animation.play("default")

	

func _on_johnny_get_animation_animation_finished() -> void:
	VariableManager.johnny_activated = true
	#VariableManager.save_variables()
	set_up_johnny_npc()
	
	get_tree().paused = false
	johnny_get_dialogue.start()
	var do_swap = await Events.pls_dialogue_finished
	if do_swap:
		swap_johnny()
	

func play_johnny():
	johnny_play_dialogue.start()
	
	var do_swap = await Events.pls_dialogue_finished
	if do_swap:
		swap_johnny()
	



func set_up_johnny_npc():
	johnny_get_animation.visible = false
	johnny_get_sprite.visible = false
	johnny_play_sprite.visible = true
	johnny_npc_collision.position.x = 16.0 # plassen der den går over play johnny


func swap_johnny():
	if VariableManager.character_id == 0:
		Events.swap_character(1)
		johnny_play_sprite.use_parent_material = true
	elif VariableManager.character_id == 1:
		Events.swap_character(0)
		johnny_play_sprite.use_parent_material = false
