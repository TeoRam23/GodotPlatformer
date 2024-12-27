extends Node2D

var wrap_horizontal = false
var wrap_vertical = false
var rd = Vector2.ZERO
var lu = Vector2.ZERO

var camera_boundary

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("ask_wrap")
	#Events.pls_set_wrap.connect(wrap_me)
	#print(get_tree().root.get_child(-1).get_children())
	
	# for å gi ny-lagde rette variabler
	#var world = get_tree().root.get_child(-1).get_children()
	#for chi in world:
		#if chi.is_in_group("CameraBoundary"):
			##print(chi)
			#camera_boundary = chi
			#wrap_horizontal = chi.wrap_horizontal
			#wrap_vertical = chi.wrap_vertical
			#rd = chi.rd
			#lu = chi.lu
			#break


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if get_parent() is CharacterBody2D:
		wrap_me(0,0,0,0)
	else:
		print("########### ExTeleChild is without parent ###########")
		print(get_parent())

func ask_wrap():
	Events.request_wrap(self)


func wrap_me(srd, slu, wr_horz, wr_vert):
	#print("sending... ", srd, ", ", slu, ", ", wr_horz, wr_vert)
	#(320, 124) and: (-320, -236)
	#var rd = Vector2(320, 124)
	#var lu = Vector2(-320, -236)
	if wrap_horizontal:
		var par = get_parent()
		if par.global_position.x > rd.x + 8:
			par.global_position.x = lu.x - 8
		if par.global_position.x < lu.x - 8:
			par.global_position.x = rd.x + 8
	if wrap_vertical:
		var par = get_parent()
		if par.global_position.y > rd.y + 8:
			par.global_position.y = lu.y - 8
		if par.global_position.y < lu.y - 8:
			par.global_position.y = rd.y + 8
			
	if srd or slu:
		rd = srd
		lu = slu
		wrap_horizontal = wr_horz
		wrap_vertical = wr_vert
