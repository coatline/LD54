extends Area2D
class_name Attack 

@export var damage_delay = 0.2
@export var damage = 1
var timer = 0

@export var friendly_damage_taker : Damage_Taker
@export var exclude_group : String
var attacking : Damage_Taker

func setup(friendly_damage_taker : Damage_Taker, exclude_group = ""):
	self.friendly_damage_taker = friendly_damage_taker
	exclude_group = exclude_group

func _process(delta):
	if attacking != null:
		timer += delta
		
		if timer >= damage_delay:
			attacking.take_damage(damage)
			timer = 0

# for animation
func die():
	queue_free()

func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	var dt = area as Damage_Taker
	if dt != null:
		if dt != friendly_damage_taker and dt.is_in_group(exclude_group) == false:
			attacking = dt
			dt.take_damage(damage)

func _on_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	var dt = area as Damage_Taker
	if dt != null:
		if dt != friendly_damage_taker and dt.is_in_group(exclude_group) == false:
			if dt == attacking:
				attacking = null
