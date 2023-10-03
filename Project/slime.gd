extends CharacterBody2D

const SPEED = 250.0
const SIGHT = 140.0

@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var damage_taker = $DamageTaker
@onready var sprite = $Sprites/Sprite2D
@onready var footstepper = $Footstepper

var player : Player = null
var speed = SPEED
var acceleration = -1
var attacking_player = false

func _physics_process(delta):
	if player == null or damage_taker.dead == true: return 
	
	speed += delta * 600 * acceleration * (1 + (speed / SPEED))
	
	var distance = self.position.distance_to(player.position)
	
	if distance < SIGHT:
		attacking_player = true
	else:
		attacking_player = false
	
	if speed > SPEED / 2.5:
		sprite.frame = 1
		scale.x = lerp(1.0, 1.25, speed / SPEED)
		scale.y = lerp(1.0, 0.9, speed / SPEED)
	else:
		anim.play("idle")
		sprite.frame = 0
	
	
	
	if speed >= SPEED:
		acceleration = -1
	elif speed < 0:
		# Don't actually move backwards
		# use the negative numbers as a timer
		if speed < -10:
			# If we are attacking the player, then we can move again
			if attacking_player:
				acceleration = 1
				speed = 0
		return
	
	
	var next_position = (position + velocity.normalized() * speed * delta) 
	velocity = (player.position - self.position).normalized() * speed
	
	if(can_move_to(next_position)):
		move_and_slide()
	
	if velocity.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

func can_move_to(pos):
	var tile = Utils.get_tile_at(pos)
	
	if tile == null:
		return false
	
	if tile.name == "Grass" || tile.name == "Dirt":
		return true
	
	return false

func player_spawned(player : Player):
	self.player = player


func _on_damage_taker_died():
	anim.play("die")
