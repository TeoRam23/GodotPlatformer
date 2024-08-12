extends Node2D
#Priority burde kanskje være 1!!!

#var throw_power = -490
#var gravity_scale = 0.7
#var throw_power = -400
#var gravity_scale = 0.52
#var throw_power = -440 ##
#var gravity_scale = 0.67 ##
#var gravity_scale = 0.0
#var throw_power = -350
#var gravity_scale = 0.4
@onready var proj_timer = $ProjTimer
@onready var spawn_anchor = $SpawnAnchor
@onready var spawn_point = $SpawnAnchor/SpawnPoint
@onready var projectile_holder = $SpawnAnchor/SpawnPoint/ProjectileHolder
@onready var polygon_arrow = $PolygonArrow
@onready var rotation_neglecter = $RotationNeglecter
@onready var mouse_tracker = $RotationNeglecter/MouseTracker

var PROJ = preload("res://explo/scenes/ex_projectile.tscn")

var holding_proj
# Called when the node enters the scene tree for the first time.
func _ready():
	Events.pls_player_died.connect(disable_me)
	new_projectile()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation_neglecter.global_rotation = 0
	#print("The pros")
	move_spawn_point(false, delta)

func _physics_process(delta):
	#print("The Frizz")
	move_spawn_point(true, delta)
	if Input.is_action_just_pressed("musL") or Input.is_action_pressed("musM"):
		print("LAUNCH")
		eject_proj()

func eject_proj():
	print("LAUNCHING 1! ", process_priority)
	#var number = get_tree().get_nodes_in_group("projectile")
	if proj_timer.time_left > 0:# and number.size() > 1:
		return
	
	#if spawn_point.get_overlapping_bodies():
		#print("there's a snake in my boot!")
	
	#var mouse = get_global_mouse_position()
	var mouse = mouse_tracker.global_position
	var angle = mouse.angle_to_point(global_position)
	#angle = deg_to_rad(172.87 + 90) # FJEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEERRRRNNNNNNNNNNNNNNN
	#var angle = global_position.angle_to_point(mouse)
	#angle = (angle * -1) + (PI *0.5)
	holding_proj.angle = angle
	holding_proj.global_position = spawn_point.global_position
	holding_proj.launch()
	
	proj_timer.start()
	new_projectile()


func new_projectile():
	var new_proj = PROJ.instantiate()
	projectile_holder.add_child(new_proj)
	
	holding_proj = new_proj
	holding_proj.the_launcher = self
	holding_proj.the_spawner = spawn_point
	holding_proj.mouse_tracker = mouse_tracker
	
	holding_proj.global_position = spawn_point.global_position
	
func move_spawn_point(is_in_physics, delta):
	#var mouse = get_global_mouse_position()
	var mouse = mouse_tracker.global_position
	#var angle = global_position.angle_to_point(mouse)
	var angle = mouse.angle_to_point(global_position)
	
	#angle = deg_to_rad(172.87 + 90) # FJEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEERRRRNNNNNNNNNNNNNNN
	#print(angle)
	
	spawn_anchor.global_rotation = angle# + PI * 0.5
	spawn_anchor.position.y = 0
	#spawn_anchor.position.y = (spawn_point.global_position.y - spawn_anchor.global_position.y) * 0.57
	spawn_anchor.position.y = (spawn_point.global_position - spawn_anchor.global_position).rotated(-global_rotation).y * 0.57
	#spawn_point.move_and_slide()
	#if spawn_point.is_on_wall():
		#spawn_point.move_and_slide()
		#
	#if is_in_physics:
		#holding_proj.global_position = spawn_point.global_position
	##else:
		##if spawn_point.is_on_wall():
			##holding_proj.global_position.x = spawn_point.global_position.x
		#
	#spawn_point.position = Vector2(-7, 0)
	
	holding_proj.global_position = spawn_point.global_position
	
	holding_proj.move_and_slide()
	if holding_proj.is_on_wall():
		holding_proj.apply_second_gravity(delta, true)
	
	polygon_arrow.global_rotation = angle# + PI * 0.5
	#polygon_arrow.position.y -= abs(spawn_anchor.position.y)
	#print("poly: ",polygon_arrow.position.y, "anch: ", spawn_anchor.position.y)
	
	
	
func disable_me():
	set_process(false)
	set_physics_process(false)
	polygon_arrow.visible = false
	
	
func _input(event):
	if event is InputEventMouseMotion and not Input.is_action_pressed("cancel"):
		var window = get_window().size
		if abs(event.relative.x) < window.x *0.1 and abs(event.relative.y) < window.y *0.1:
			mouse_tracker.global_position += event.relative
			
			# For å begrense pekeren
			#if abs(mouse_tracker.position.x) >= 100:
				#mouse_tracker.position.x = 100 * sign(mouse_tracker.position.x)
			#if abs(mouse_tracker.position.y) >= 100:
				#mouse_tracker.position.y = 100 * sign(mouse_tracker.position.y)
