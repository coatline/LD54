extends Area2D

@export var item : Item

@onready var sprite2d = $"Sprite2D"

func _ready():
	sprite2d.texture = item.outline_sprite
	if item.progress <= SaveHandler.game_save.progress:
		queue_free()

func _on_body_entered(body):
	var player = body as Player
	
	if player != null:
		player.pickup_item(item)
		queue_free()
