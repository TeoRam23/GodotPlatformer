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
@onready var mouse_sprite = $RotationNeglecter/MouseSprite
@onready var touch_control = $CanvasLayer/TouchControl
@onready var touch_base_sprite = $CanvasLayer/TouchControl/TouchBaseSprite
@onready var stick_base = $CanvasLayer/TouchControl/StickBase
@onready var touch_stick_node = $CanvasLayer/TouchControl/StickBase/TouchStickNode
@onready var touch_stick_sprite = $CanvasLayer/TouchControl/StickBase/TouchStickSprite

var low_gravity = false
var mouse_is_locked = true
var settings_locked_cursor = true


var PROJ = preload("res://explo/scenes/ex_projectile.tscn")

var holding_proj
# Called when the node enters the scene tree for the first time.
func _ready():
	Events.pls_player_died.connect(disable_me)
	Events.level_completed.connect(disable_me)
	Events.pls_enter_extra.connect(disable_me)
	Events.pls_low_gravity.connect(lower_gravity)
	settings_locked_cursor = Settings.locked_cursor
	if Settings.touch_mode:
		touch_control.visible = true
	
	new_projectile()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation_neglecter.global_rotation = 0
	#print("The pros")
	move_spawn_point(false, delta)

func _physics_process(delta):
	#print("The Frizz")
	move_spawn_point(true, delta)
	if (Input.is_action_just_pressed("musL") and not Settings.touch_mode) or Input.is_action_pressed("musM") or Settings.constant_throwing or (Input.is_action_just_pressed("touchMusL") and Settings.touch_mode):
		#print("LAUNCH")
		eject_proj()
	

func eject_proj():
	#print("LAUNCHING 1! ", process_priority)
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
	holding_proj.low_gravity = low_gravity
	
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
	
	#var org = get_viewport_transform().origin
	#var offs = global_position - org
	#polygon_arrow.global_position.x = org.x + snappedi(offs.x, 1)
	#polygon_arrow.global_position.y = org.y + snappedi(offs.y, 1)
	#print(org)
	#polygon_arrow.position.y -= abs(spawn_anchor.position.y)
	#print("poly: ",polygon_arrow.position.y, "anch: ", spawn_anchor.position.y)
	#print("first poly: ", polygon_arrow.global_position)
	#polygon_arrow.position = Vector2.ZERO
	#polygon_arrow.global_position.x = snappedi(polygon_arrow.global_position.x, 1)
	#polygon_arrow.global_position.y = snappedi(polygon_arrow.global_position.y, 1)
	#print("second poly: ", polygon_arrow.global_position)
	
	
	
func disable_me():
	set_process(false)
	set_physics_process(false)
	polygon_arrow.visible = false
	mouse_is_locked = false
	
	
	
func _input(event):
	if event is InputEventMouseMotion and not Input.is_action_pressed("cancel") and not Settings.touch_mode:
		
		mouse_tracker.global_position.x += event.position.x - 320.0
		mouse_tracker.global_position.y += event.position.y - 180.0
		Input.warp_mouse(get_window().size * 0.5)
		
		## Tidligere verson av å flytte pekeren
		#elif 2 == 1:
			#mouse_tracker.global_position += event.relative
			#if VariableManager.mouse_warped.x or VariableManager.mouse_warped.y:
				#var window = get_window().size
				#var checker = VariableManager.mouse_warped
				#if checker.x == 2:
					#mouse_tracker.global_position.x += 640
				#elif checker.x >= window.x * 0.5:
					#mouse_tracker.global_position.x -= 640
				#if checker.y == 2:
					#mouse_tracker.global_position.y += 360
				#elif checker.y >= window.y * 0.5:
					#mouse_tracker.global_position.y -= 360
		
		snap_mouse_tracker()
		# dette under er flyttet til snap_mouse_tracker()
		#var to_object = mouse_tracker.position - Vector2.ZERO #hvorfor er "- Vector2.ZERO" her? 
		#var differanse = to_object.length()
		#var radius = 75
		##print(differanse)
		#if differanse > radius and mouse_is_locked and settings_locked_cursor:
			#mouse_tracker.position = to_object.normalized() * radius
			#
		#mouse_tracker.position.x = snappedf(mouse_tracker.position.x, 0.5)
		#mouse_tracker.position.y = snappedf(mouse_tracker.position.y, 0.5)
		#
		#mouse_sprite.position.x = snappedi(mouse_tracker.position.x, 1)
		#mouse_sprite.position.y = snappedi(mouse_tracker.position.y, 1)
			
			#print(mouse_tracker.position)
			# For å begrense pekeren
			#if abs(mouse_tracker.position.x) >= 100:
				#mouse_tracker.position.x = 100 * sign(mouse_tracker.position.x)
			#if abs(mouse_tracker.position.y) >= 100:
				#mouse_tracker.position.y = 100 * sign(mouse_tracker.position.y)
		
	#if event is InputEventScreenTouch and not Input.is_action_pressed("cancel"):
		#touch_dragging = true
	elif event is InputEventScreenDrag and not Input.is_action_pressed("cancel"):
		#print(event.position)
		var mouse_pos = stick_base.get_local_mouse_position()
		
		#if not touch_mouse_checker.shape.get_rect().has_point(mouse_pos):
			#return
		if event.position.x < 432 or event.position.y > 208:
			return
		
		touch_stick_node.position = event.position - stick_base.position
		
		var to_object = touch_stick_node.position - Vector2.ZERO #hvorfor er dette her?
		var differanse = to_object.length()
		var radius = 48
		
		#print(differanse)
		if differanse > radius:
			touch_stick_node.position = to_object.normalized() * radius
		
		mouse_tracker.position = touch_stick_node.position
		
		touch_stick_sprite.position.x = snappedi(touch_stick_node.position.x, 1)
		touch_stick_sprite.position.y = snappedi(touch_stick_node.position.y, 1)
		snap_mouse_tracker()
	

func snap_mouse_tracker():
	var to_object = mouse_tracker.position - Vector2.ZERO #hvorfor er "- Vector2.ZERO" her? 
	var differanse = to_object.length()
	var radius = 75
	#print(differanse)
	if differanse > radius and mouse_is_locked and settings_locked_cursor:
		mouse_tracker.position = to_object.normalized() * radius
		
	mouse_tracker.position.x = snappedf(mouse_tracker.position.x, 0.5)
	mouse_tracker.position.y = snappedf(mouse_tracker.position.y, 0.5)
	
	mouse_sprite.position.x = snappedi(mouse_tracker.position.x, 1)
	mouse_sprite.position.y = snappedi(mouse_tracker.position.y, 1)
	

func lower_gravity():
	low_gravity = true
