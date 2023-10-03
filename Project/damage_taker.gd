extends Area2D
class_name Damage_Taker

@export var max_health = 0;
@export var flash_anim : Flash_Animation
@export var root : Node
@export var dont_destroy_root : bool = false
@onready var hurt_sound = $HurtSound

var dead = false
var health = 0;

signal health_changed(current, max)
signal died

func _ready():
	health = max_health
	health_changed.emit(health, max_health)

func take_damage(dmg):
	health -= dmg
	
	health_changed.emit(health, max_health)
	
	flash_anim.animate()
	
	if health <= 0:
		dead = true
		died.emit()
#
#		if dont_destroy_root == false:
#			root.queue_free()
	else:
		hurt_sound.playing = true

func destroy_root():
	root.queue_free()
