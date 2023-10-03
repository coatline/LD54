extends ProgressBar

@onready var player : Player = $"../../Player"
@onready var health_numbers = $"../HealthNumbers"
@onready var animation_player = $AnimationPlayer

func _ready():
	player.damage_taker.health_changed.connect(health_changed)
	health_changed(player.damage_taker.health, player.damage_taker.max_health)

func health_changed(current, max):
	health_numbers.text = str(current) + "/" + str(max)
	value = (float(current) / float(max)) * 100
	animation_player.play("hurt")
