extends StaticBody2D

var ALIVE = false
var pausing = true

var gonna_change = false

@onready var control = $Control
@onready var sprite = $Sprite2D
@onready var conway_detector = $ConwayDetector

# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().toggle_life.connect(tole_life)
	get_parent().update_please.connect(lets_update)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if pausing:
		set_population()
	else:
		do_the_conway()


func do_the_conway():
	if conway_detector.get_overlapping_bodies():
		var neighbors = conway_detector.get_overlapping_bodies()
		var frens = 0
		for bro in neighbors:
			if bro.ALIVE and bro != self:
				frens += 1
		
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


func change_state():
	ALIVE = !ALIVE
	if ALIVE:
		modulate = Color(0.604, 0.871, 0.557)
	if !ALIVE:
		modulate = Color(0.87, 0.87, 0.87)



func set_population():
	if Input.is_action_pressed("LMB") and !ALIVE:
		var mouse_position = get_global_mouse_position()
		if control.get_rect().has_point(to_local(mouse_position)):
			print("get changed!")
			change_state()
	
	if Input.is_action_pressed("RMB") and ALIVE:
		var mouse_position = get_global_mouse_position()
		if control.get_rect().has_point(to_local(mouse_position)):
			print("get changed!")
			change_state()
		

func tole_life():
	pausing = !pausing
