extends Label

@onready var foreground = $Foreground

@onready var timer = $Timer

func _ready():
	timer.timeout.connect(disappear)
	Utils.display_message.connect(display)

func display(message : String, time : float):
	text = message
	foreground.text = message
	visible = true
	timer.wait_time = time
	timer.start()

func disappear():
	visible = false
