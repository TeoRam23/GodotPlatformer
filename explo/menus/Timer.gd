extends Label

@export var all_timer = false

var time_elapsed = 0.0
var time_stop = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.pls_player_died.connect(stop_time)
	Events.level_completed.connect(stop_time)
	if all_timer:
		time_elapsed = VariableManager.all_time



func _process(delta):
	if !time_stop:
		update_time(delta)


func update_time(delta):
	time_elapsed += delta
	time_elapsed = snappedf(time_elapsed, 0.01666666666667)
	#time_elapsed += 0.01666666666667
	var minutes = int(floor(time_elapsed * 0.01666666666667)) % 60
	var hours = floor(time_elapsed / 3600)
	var seconds = int(time_elapsed) % 60
	var millis = (time_elapsed - floor(time_elapsed)) * 1000
	var time_text = "%02d:%02d.%03d" % [minutes, seconds, millis]
	if hours:
		time_text = str(hours)+":" + time_text
	text = str(time_text)

func stop_time():
	if all_timer:
		VariableManager.all_time = time_elapsed
	time_stop = true
func start_time():
	time_stop = false
