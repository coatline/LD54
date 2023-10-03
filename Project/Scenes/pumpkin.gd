extends CharacterBody2D

const ATTACK_DELAY = 0.5
const ATTACK_OFFSET = 10
const SIGHT = 150.0
const RANGE = 100.0
const SPEED = 90.0

@onready var snowball_scene = preload("res://Scenes/snowball_attack.tscn")

@onready var footstepper = $Footstepper
@onready var damage_taker = $DamageTaker
@onready var anim : AnimationPlayer = $AnimationPlayer
var player : Player = null
var attacking = false
var attack_timer = 0

func _physics_process(delta):
	if player == null or damage_taker.dead == true: return
	
	attack_timer += delta
	
	var dist = position.distance_to(player.position)
	
	if dist > SIGHT:
		anim.play("idle")
		return
	elif dist <= RANGE:
		if attack_timer > ATTACK_DELAY:
			attack_timer = 0
			attack(player.position)
	
	var next_position = (position + velocity.normalized() * SPEED * delta) 
	
	velocity = (player.position - self.position).normalized() * SPEED
	
	anim.play("move")
	
	var can_move_there = can_move_to(next_position)
	
	if(can_move_there):
		footstepper.moved(Utils.get_tile_at(next_position).footstep_sound)
		move_and_slide()

func attack(target_position):
	var direction = (target_position - position).normalized()
	var instance : ProjectileAttack= snowball_scene.instantiate()
	instance.position = self.position + (direction * ATTACK_OFFSET)
	instance.setup(damage_taker, "enemy")
	(instance as ProjectileAttack).set_direction(direction)
	get_tree().root.add_child(instance)

func can_move_to(pos):
	var tile = Utils.get_tile_at(pos)
	
	if tile == null:
		return false
	
	if tile.name == "Snow":
		return true
	
	return false

func player_spawned(player : Player):
	self.player = player


func _on_damage_taker_died():
	anim.play("die")
