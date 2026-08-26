extends HBoxContainer

@onready var johnny_container: HBoxContainer = $JohnnyContainer
@onready var johnny_label: Label = $JohnnyContainer/JohnnyLabel

@onready var key_container: HBoxContainer = $KeyContainer
@onready var key_label: Label = $KeyContainer/KeyLabel

@export var world_number = "1"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var levels = VariableManager.levels_completed
	var johnnies = 0
	
	for level in levels:
		if String(level.id)[0] == world_number and level.johnny_collected == true:
			johnnies += 1
	johnny_label.text = str(johnnies) + "/8"
	
	var var_keys = VariableManager.level_keys
	var keys = 0
	
	for key in var_keys:
		if key[0] == world_number:
			keys += 1
			#print(key)
	
	if keys != 0:
		key_container.visible = true
		key_label.text = str(keys) + "/4"
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
