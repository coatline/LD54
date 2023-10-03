extends AudioStreamPlayer2D

@export var min_delay = 1.0
@export var max_delay = 2.0

var disabled = false

func _ready():
	start()

func start():
	while(true):
		await (get_tree().create_timer(randf_range(min_delay, max_delay)).timeout)
		if disabled == false:
			playing = true
