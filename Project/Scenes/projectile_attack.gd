extends Area2D
class_name ProjectileAttack

const LIFE_TIME = 1.75
@onready var sprite_2d = $Sprite2D
@export var damage = 1

var direction : Vector2
var life_timer = 0

func set_direction(dir):
	direction = dir

func _physics_process(delta):
	life_timer += delta
	
	position += direction * 3.5
	
	if life_timer > LIFE_TIME - 1:
		sprite_2d.modulate.a -= delta * 4
		
		if sprite_2d.modulate.a >= 1:
			queue_free()


@export var friendly_damage_taker : Damage_Taker
@export var exclude_group : String

func setup(friendly_damage_taker : Damage_Taker, exclude_group = ""):
	self.friendly_damage_taker = friendly_damage_taker
	self.exclude_group = exclude_group

func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	var dt = area as Damage_Taker
	if dt != null:
		if dt != friendly_damage_taker and dt.is_in_group(exclude_group) == false:
			dt.take_damage(damage)
			queue_free()
