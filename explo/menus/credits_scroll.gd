extends Node2D

var start_screen = load("res://explo/menus/start_screen.tscn")

@onready var credits_container: VBoxContainer = $CreditsContainer
@onready var auto_container: VBoxContainer = $CreditsContainer/AutoContainer

@onready var title_label: Label = $TitleLabel
@onready var name_label: Label = $NameLabel
@onready var pad_small: Label = $PadSmall
@onready var pad_big: Label = $PadBig

@onready var skip_button: Button = $SkipButton

var scroll_speed := 0.5
var scroll_speed_fast := 4.0

var credits_length = 360

var credits_array = [
	["Game Design",
	"Liam Collins",
	"The Guy"
	],
	["Programming",
	"Me :)"
	],
	["Game Design",
	"Liam Backster",
	"The Guy"
	],
	["Programming",
	"Me :)"
	],
	["Game Design",
	"Liam Backster",
	"The Guy"
	],
	["Programming",
	"Me :)"
	],
	["Game Design",
	"Liam Backster",
	"The Guy"
	],
	["Programming",
	"Me :)"
	],
	["Game Design",
	"Liam Backster",
	"The Guy"
	],
	["Programming",
	"Me :)"
	],
	
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for item in credits_array:
		set_up_section(item)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("start") or Input.is_action_pressed("musL"):
		credits_container.position.y -= scroll_speed_fast
	credits_container.position.y -= scroll_speed
	
	if credits_container.global_position.y + credits_container.size.y < 0:
		get_tree().change_scene_to_packed(start_screen) 
	
	if (Input.is_action_just_pressed("start") or Input.is_action_just_pressed("musL") or Input.is_action_just_pressed("cancel")) \
			and skip_button.visible == false:
		print("doin thin")
		skip_button.visible = true
		var tween = get_tree().create_tween()
		tween.tween_property(skip_button, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.5)


func set_up_section(section_array: Array) -> void:
	var new_title = title_label.duplicate()
	new_title.text = section_array[0]
	auto_container.add_child(new_title)
	var new_padding = pad_small.duplicate()
	auto_container.add_child(new_padding)
	
	var index = 0
	for item in section_array:
		if index != 0:
			var new_name = name_label.duplicate()
			new_name.text = item
			auto_container.add_child(new_name)
		index += 1
	
	var new_padder = pad_big.duplicate()
	auto_container.add_child(new_padder)
	


func _on_skip_button_pressed() -> void:
	#print("ye i work")
	get_tree().change_scene_to_packed(start_screen) 
