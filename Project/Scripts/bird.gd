extends AnimatedSprite2D
class_name Bird  

const FLYING_SCALE = 1.5
const DESPAWN_DIST = 600
const SPOOKED_SPEED = 2
const CASUAL_SPEED = 1.25
const SPEED_RANDOMNESS = 0.5
const MAX_HEIGHT = 75
const MAX_VERTICAL_SPEED = 15
const MIN_VERTICAL_SPEED = 2

@onready var flying_flap_sound = $FlyingFlapSound
@onready var flapping_sound = $FlappingSound
@onready var shadow : Sprite2D = $Shadow
var initial_shadow_offset

var spooked_position : Vector2
var spawned_in = false
var flying = false
var spooked = false
var direction : Vector2
var speed = randf_range(CASUAL_SPEED, CASUAL_SPEED + SPEED_RANDOMNESS)
var vertical_speed = 0
var height = 0
signal despawned

var player : Player = null

# This is called before _ready()
func setup(player : Player, flying_in : bool):
	flying = flying_in
	self.player = player
	direction = ((player.position + Vector2(randf_range(-40, 40), randf_range(-40, 40))) - position).normalized()
	spawned_in = true

func _ready():
	initial_shadow_offset = shadow.position
	
	if flying:
		height = randf_range(0, MAX_HEIGHT)
		play("Fly", 1)
	
	vertical_speed = randf_range(MIN_VERTICAL_SPEED, MAX_VERTICAL_SPEED)


func _process(delta):
	if player != null: 
		var dist = position.distance_to(player.position)
		if spawned_in and dist > DESPAWN_DIST:
			despawned.emit()
			queue_free()
			return
#	elif spooked and position.distance_to(spooked_position) > MANUAL_PLACEMENT_DESPAWN_DIST:
#		despawned.emit()
#		queue_free()
#		return
	var height_percentage = height / MAX_HEIGHT
	
	shadow.position = Vector2(initial_shadow_offset.x, lerpf(initial_shadow_offset.y, MAX_HEIGHT, height_percentage))
	self.scale = Vector2(lerpf(1, FLYING_SCALE, height_percentage), lerpf(1, FLYING_SCALE, height_percentage))
	
	if flying:
		position += direction * speed
		
		flying_flap_sound.disabled = false
		
		if height < MAX_HEIGHT:
			height += delta * vertical_speed
		else:
			height = MAX_HEIGHT
		
		play("Fly")
	else:
		flying_flap_sound.disabled = true
		height = 0
		play("Eat")
	
	if direction.x < 0:
		flip_h = true
	else:
		flip_h = false

func _on_detection_area_body_entered(body):
	if flying or body is Player == false: return
	
	if player == null:
		player = body as Player
	
	spooked_position = position
	
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	spooked = true
	flying = true
	
	speed = randf_range(SPOOKED_SPEED, SPOOKED_SPEED + SPEED_RANDOMNESS)
	flapping_sound.playing = true
	play("Fly", 2)
