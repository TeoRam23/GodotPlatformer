extends ColorRect


# Called when the node enters the scene tree for the first time.
#func _ready():
	#Events.pls_player_died.connect(reset_level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func reveal_level():
	#visible = true
	var tween = create_tween()
	tween.tween_property(self, "size", size, 0.6) # litt delay
	tween.tween_property(self, "position", position + Vector2(672 - 16, 0), 0.25).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func transition_level():
	var tween = create_tween()
	tween.tween_property(self, "position", position + Vector2(-672 + 16, 0), 0.25).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	await tween.finished
	#get_tree().paused = false
	return

func reset_level():
	print("yayay")
	await get_tree().create_timer(0.5).timeout
	var tween = create_tween()
	tween.tween_property(self, "position", position + Vector2(-672 + 16, 0), 0.25).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	await  tween.finished
	get_tree().paused = false
	get_tree().reload_current_scene()
