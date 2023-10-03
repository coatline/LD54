extends AudioStreamPlayer2D
class_name Ambience

const MOVE_SPEED = 75
const OFF_DB = -40

var target_db = 0

func turn_off():
	target_db = OFF_DB

func turn_on():
	if playing: return
	target_db = 0
	playing = true

func _process(delta):
	if volume_db <= OFF_DB:
		if playing:
			playing = false
	
	volume_db = move_toward(volume_db, target_db, delta * MOVE_SPEED)
