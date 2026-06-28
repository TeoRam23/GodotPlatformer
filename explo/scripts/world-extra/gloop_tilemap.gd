extends TileMap

@onready var sub_viewport = $SubViewport
#@onready var sub_viewport = $SubViewportContainer/SubViewport
@onready var camera_2d = $Camera2D
@onready var sub_camera = $SubViewport/SubCamera


#@onready var gloop_holder_node = $SubViewportContainer/SubViewport/GloopHolderNode
@onready var gloop_holder_node = $SubViewport/GloopHolderNode
#@onready var gloop_holder_node = $GloopHolderNode
@onready var shader_rect = $ShaderRect


# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("set_camera")
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
	#print("START")
	#print("hold pos: ", gloop_holder_node.position, " and... ", gloop_holder_node.global_position)
	##sub_viewport.world_2d = get_world_2d()
	#for child in gloop_holder_node.get_children():
		#print(child, " my position is ", child.position)
	#print("END")

func set_camera():
	var children = get_children()
	#print("is this printed dude? ", children)
	
	var left_top: Vector2
	var right_bot: Vector2
	
	for child in children:
		if child.is_in_group("gloop_hazard"):
			#print("found somebody: ", child.global_position)
			var chi_gp = child.global_position
			
			if chi_gp.x < left_top.x:
				left_top.x = chi_gp.x
			elif chi_gp.x > right_bot.x:
				right_bot.x = chi_gp.x
			if chi_gp.y < left_top.y:
				left_top.y = chi_gp.y
			elif chi_gp.y > right_bot.y:
				right_bot.y = chi_gp.y
			#var child_pos = child.global_position
			
			var chi_sprite
			var babies = child.get_children()
			for baby in babies:
				if baby.is_in_group("Sprite"):
					chi_sprite = baby
					chi_sprite.frame = randi_range(1,4)
					var rot_rand = randi_range(1,4)
					# Jeg prøvde å rotere den for å ha flere variasjoner, men det virket ikke helt og jeg ga opp.
					#if rot_rand == 1:
						#chi_sprite.rotation = 90
					#if rot_rand == 2:
						#chi_sprite.rotation = 180
					#elif rot_rand == 3:
						#chi_sprite.rotation = 270
					
			if chi_sprite:
				child.remove_child(chi_sprite)
				gloop_holder_node.add_child(chi_sprite)
				chi_sprite.global_position.x = chi_gp.x + 0.5 # 0.5 er for å sette tilbake offsetten slik at den ikke står på x.5 selv
				chi_sprite.global_position.y = chi_gp.y #+ 0.5
			
	#print(left_top, " and ", right_bot)
	sub_viewport.size.x = abs(left_top.x) + abs(right_bot.x) + 40
	sub_viewport.size.y = abs(left_top.y) + abs(right_bot.y) + 40
	
	shader_rect.global_position = left_top - Vector2(20, 20)
	
	sub_camera.global_position = shader_rect.global_position + (sub_viewport.size*0.5)
	#sub_viewport.size = shader_rect.size
	
	
	


#func _input(event):
	#if event.is_action_pressed("right"):
		#sub_camera.position.x += 15
	#if event.is_action_pressed("left"):
		#sub_camera.position.x -= 15
	#if event.is_action_pressed("up"):
		#sub_camera.position.y -= 15
	#if event.is_action_pressed("down"):
		#sub_camera.position.y += 15
