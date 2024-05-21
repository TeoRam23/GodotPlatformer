extends StaticBody2D

var ALIVE = false
var pausing = true

var gonna_change = false

var size = 0

@onready var control = $Control
@onready var sprite = $Sprite2D
@onready var conway_detector = $ConwayDetector

var CARC = preload("res://life/infinite/inf_conway2.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
#	print("I AM READY")
	get_parent().inf_toggle_life.connect(tole_life)
	get_parent().inf_update_please.connect(lets_update)
	get_parent().inf_lets_carcass.connect(place_carcass)
	kill_twin()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	if !ALIVE:
#		print("we are the carc")
#		kill_twin()
	conway_detector.set_collision_mask_value(5, true)
	if pausing:
		set_population()
	else:
		do_the_conway()
			
		place_carcass()
	kill_twin()


func do_the_conway():
	
	var neighbors = []
	if conway_detector.get_overlapping_bodies():
		neighbors = conway_detector.get_overlapping_bodies()
	var frens = 0
	for bro in neighbors:
#		print("Bro pos: ", bro.position)
		if bro.ALIVE and bro != self:
			frens += 1
#	print("Col: ", collision_layer)
#	print(frens, ", ", position)

	if ALIVE:
		if frens < 2:
			gonna_change = true
		elif frens == 2 or frens == 3:
			gonna_change = false
		elif frens > 3:
			gonna_change = true
	elif !ALIVE and frens == 3:
			gonna_change = true
	else:
		gonna_change = false


func lets_update():
	if gonna_change:
		change_state()
	
	check_death()


func change_state():
#	print("and NOW WE CHANGE")
	ALIVE = !ALIVE
	if ALIVE:
#		print("we're so back")
		modulate = Color(0.604, 0.871, 0.557)#, 1)
		set_collision_layer_value(1, true)

	if !ALIVE:
#		print("we're so ded")
		queue_free()


func set_population():
#	if Input.is_action_pressed("LMB") and !ALIVE:
#		var mouse_position = get_global_mouse_position()
#		if control.get_rect().has_point(to_local(mouse_position)):
#			print("get changed!")
#			change_state()

	if Input.is_action_pressed("RMB") and ALIVE:
		var mouse_position = get_global_mouse_position()
		if control.get_rect().has_point(to_local(mouse_position)):
			print("get changed!")
#			change_state()
			queue_free()


func place_carcass():
	if !ALIVE:
		return
	conway_detector.set_collision_mask_value(5, true)
	
#	print(position, ", ", size)
	for y in 3:
		for x in 3:
#			print(x, ", ", y)
			var new_x = position.x - size + (size * x)
			var new_y = position.y - size + (size * y)
			
			if conway_detector.get_overlapping_bodies():
				conway_detector.set_collision_mask_value(5, true)
				var bean = false
				var neighbors = conway_detector.get_overlapping_bodies()
				if neighbors.size() == 9:
					return
				for bro in neighbors:
					if bro.position == Vector2(new_x, new_y):
						bean = true
						break
				if bean:
					continue

############################################ de bryr seg ikke om de ny-plasserte likene. kanskje de ikke finnes enda og de dukker opp samtidig?

			var new_carcass = CARC.instantiate()
			
			new_carcass.position.x = position.x - size + (size * x)
			new_carcass.position.y = position.y - size + (size * y)
			new_carcass.scale.x = size
			new_carcass.scale.y = size
			new_carcass.size = size
			new_carcass.pausing = false
			new_carcass.set_collision_layer_value(5, true)
			
			
			get_parent().add_child(new_carcass)
#			print("DID IIIIIIIIITTTTTTT WOOOOOOOOOOOOOOOOO CARCASSES")
#	if conway_detector.get_overlapping_bodies():
#		print(conway_detector.get_overlapping_bodies())


func kill_twin():
	conway_detector.set_collision_mask_value(5, true)
	if conway_detector.get_overlapping_bodies():
		conway_detector.set_collision_mask_value(5, true)
		var neighbors = conway_detector.get_overlapping_bodies()
		
		for bro in neighbors:
			if bro != self:
#				print(bro.position, ", ", position, ":	", self)
				if bro.position == position:
#					print("we kll")
#					print("letsago I murder bro")
					bro.free()
					

func check_death():
	if !ALIVE:
		if conway_detector.get_overlapping_bodies():
			conway_detector.set_collision_mask_value(5, true)
			var neighbors = conway_detector.get_overlapping_bodies()
			for bro in neighbors:
				if bro.ALIVE:
					return
		queue_free()
		
		
func tole_life():
	pausing = !pausing
	place_carcass()
