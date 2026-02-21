extends HBoxContainer

@onready var select_world: CanvasLayer = $".."
@onready var grid_container = $GridContainer
@onready var level_title = $"../LevelTitle"
@onready var best_time_label = $"../BestTimeLabel"

@onready var extra_container: VBoxContainer = $ExtraContainer
@onready var bonus_a: Button = $ExtraContainer/BonusA
@onready var padding_a: ColorRect = $ExtraContainer/PaddingA
@onready var bonus_b: Button = $ExtraContainer/BonusB
@onready var padding_b: ColorRect = $ExtraContainer/PaddingB
@onready var bonus_c: Button = $ExtraContainer/BonusC
@onready var padding_c: ColorRect = $ExtraContainer/PaddingC
@onready var bonus_d: Button = $ExtraContainer/BonusD
@onready var padding_d: ColorRect = $ExtraContainer/PaddingD
@onready var bonus_e: Button = $ExtraContainer/BonusE
@onready var padding_e: ColorRect = $ExtraContainer/PaddingE

@onready var icon_no_walking: TextureRect = $"../IconBonusContainer/IconNoWalking"
@onready var icon_constant_throwing: TextureRect = $"../IconBonusContainer/IconConstantThrowing"
@onready var icon_perfection: TextureRect = $"../IconBonusContainer/IconPerfection"
@onready var icon_zero_gravity: TextureRect = $"../IconBonusContainer/IconZeroGravity"

var world_is_enabled = false


# Called when the node enters the scene tree for the first time.
func _ready():
	var buttons = grid_container.get_children()
	#print(buttons)
	for butt in buttons:
		if butt.is_in_group("level_button_group"):
			butt.label = level_title
			butt.time_label = best_time_label
			
			butt.tin_no_walking = icon_no_walking
			butt.tin_constant_throwing = icon_constant_throwing
			butt.tin_perfection = icon_perfection
			butt.tin_zero_gravity = icon_zero_gravity
			
			if butt.disabled == false:
				world_is_enabled = true
			
	if world_is_enabled == false:
		# scummy code, but whatever
		var parent = select_world.get_parent()
		if parent.has_method("disable_me"):
			parent.disable_me()
	
	call_deferred("set_bonus_levels")
	
	
	
	

func set_bonus_levels():
	var show_bonus = 5
	if bonus_a.visible == false:
		padding_a.visible = true
		show_bonus -= 1
	if bonus_b.visible == false:
		padding_b.visible = true
		show_bonus -= 1
	if bonus_c.visible == false:
		padding_c.visible = true
		show_bonus -= 1
	if bonus_d.visible == false:
		padding_d.visible = true
		show_bonus -= 1
	if bonus_e.visible == false:
		padding_e.visible = true
		show_bonus -= 1
	
	if show_bonus == 0:
		extra_container.visible = false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass



#func _on_back_button_pressed():
	#get_parent().get_parent().hide_selection()
