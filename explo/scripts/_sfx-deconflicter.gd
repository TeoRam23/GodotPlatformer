extends Node


func _ready() -> void:
	Events.pls_send_camera_node.connect(recieve_camera_node)

var current_camera_node: Camera2D

## Ensures multiple copies of the same sound don't play simultaneously.
##
## By calling SfxDeconflicter.play() with multiple AudioStreamPlayers, this script monitors when those
## AudioStreamPlayers play to prevent two copies of the same sound from playing simultaneously. This prevents the
## player from hearing one very loud sound effect when several things happen at once.

## Number of milliseconds before the same sound can play a second time.
const DEFAULT_SUPPRESS_SFX_MSEC := 20

const distance_from_camera := 370

## key: (String) audio stream resource path
## value: (int) the amount of time passed in milliseconds between when the engine started and when the sound effect was
## 	last played
var last_played_msec_by_resource_path := {}
var last_played_position := Vector2.ZERO

## Plays the specified sound effect, unless it was recently played.
##
## Parameters:
## 	'player': The AudioStreamPlayer to play. This is not explicitly typed as an AudioStreamPlayer because it also
## 		supports AudioStreamPlayer2D and AudioStreamPlayer3D nodes.
##
## 	'from_position': The sound effect's start position.
func play(player: Node, from_position: float = 0.0) -> void:
	if not player:
		return
	
	if not player is AudioStreamPlayer \
			and not player is AudioStreamPlayer2D:
		push_warning("Unrecognized AudioStreamPlayer: %s (%s)" % [player.get_path(), player.get_class()])
		return
	
	if not should_play(player):
		# suppress sound effect; sound was played too recently
		pass
	else:
		# play sound effect
		player.play(from_position)


## Returns 'true' if the specified sound effect should play, updating our state to ensure it doesn't play again.
##
## Calling this method results in a state change. It should only be called if the caller wants to play the sound.
##
## Parameters:
## 	'player': The AudioStreamPlayer to play. This is not explicitly typed as an AudioStreamPlayer because it also
## 		supports AudioStreamPlayer2D and AudioStreamPlayer3D nodes.
##
## 	'suppress_sfx_msec': Number of milliseconds before the sound can play a second time.
func should_play(player: Node, suppress_sfx_msec: int = DEFAULT_SUPPRESS_SFX_MSEC) -> bool:
	if not player:
		return false
		
	var check_with_cam := true
	if not is_instance_valid(current_camera_node):
		check_with_cam = false
	
	if not player is AudioStreamPlayer \
			and not player is AudioStreamPlayer2D:
		push_warning("Unrecognized AudioStreamPlayer: %s (%s)" % [player.get_path(), player.get_class()])
		return false
	
	var result := true
	var resource_path: String = player.stream.resource_path
	var last_played_msec: int = last_played_msec_by_resource_path.get(resource_path, 0)
	
	if check_with_cam:
		if player is AudioStreamPlayer2D \
				and current_camera_node is Camera2D \
				and player.global_position.distance_to(current_camera_node.global_position) > distance_from_camera:
			result = false
			return result

	if last_played_msec + suppress_sfx_msec >= Time.get_ticks_msec():
		# suppress sound effect; sound was played too recently
		result = false
	else:
		# update 'last_played'; sound is about to be played
		last_played_msec_by_resource_path[resource_path] = Time.get_ticks_msec()
		if player is AudioStreamPlayer2D:
			last_played_position = player.global_position
	return result

func recieve_camera_node(camera: Camera2D):
	current_camera_node = camera
