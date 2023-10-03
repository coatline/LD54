extends CharacterBody2D

const ATTACK_DELAY = .25
const ATTACK_OFFSET = 10
const SIGHT = 150.0
const RANGE = 35.0
const SPEED = 90.0

@onready var snowball_scene = preload("res://Scenes/snowball_attack.tscn")

@onready var damage_taker = $DamageTaker
@onready var anim : AnimationPlayer = $AnimationPlayer
var player : Player = null
var attacking = false
var attack_timer = 0.0

func _physics_process(delta):
	if player == null or damage_taker.dead: return
	
	if attacking: return
	
	attack_timer += delta
	
	var dist = position.distance_to(player.position)
	
	if dist > SIGHT:
		anim.play("idle")
		return
	elif dist <= RANGE:
		if attack_timer > ATTACK_DELAY:
			anim.play("attack", -1, 1.25)
			attacking = true
			attack_timer = 0
			return
	
	anim.play("move")
	
	var next_position = (position + velocity.normalized() * SPEED * delta) 
	
	velocity = (player.position - self.position).normalized() * SPEED
	
	if(can_move_to(next_position)):
		move_and_slide()

func can_move_to(pos):
	var tile = Utils.get_tile_at(pos)
	
	if tile == null:
		return false
	
	if tile.name == "Rain":
		return true
	
	return false

func start_attack():
	attacking = true

func end_attack():
	attacking = false

func player_spawned(player : Player):
	self.player = player


func _on_damage_taker_died():
	anim.play("die")
