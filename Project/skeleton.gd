extends CharacterBody2D

const SIGHT = 150.0
const SPEED = 145.0

@onready var damage_taker = $DamageTaker
@onready var footstepper = $Footstepper
@onready var anim : AnimationPlayer = $AnimationPlayer
var player : Player = null
var attacking = false

func _physics_process(delta):
	if player == null or damage_taker.dead == true: return
	
	if position.distance_to(player.position) > SIGHT:
		anim.play("idle")
		return
	
	var next_position = (position + velocity.normalized() * SPEED * delta) 
	velocity = (player.position - self.position).normalized() * SPEED
	anim.play("move")
	
	if(can_move_to(next_position)):
		footstepper.moved(Utils.get_tile_at(next_position).footstep_sound)
		move_and_slide()

func can_move_to(pos):
	var tile = Utils.get_tile_at(pos)
	
	if tile == null:
		return false
	
	if tile.name == "Sand":
		return true
	
	return false

func player_spawned(player : Player):
	self.player = player

func _on_damage_taker_died():
	anim.play("die")
