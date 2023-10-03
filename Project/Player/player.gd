extends CharacterBody2D
class_name Player

const SPEED = 150.0
const ATTACK_DELAY = .125
const MAX_ATTACK_OFFSET = 35

@onready var attack_scene = preload("res://player_attack.tscn")
@onready var idle_sprite = preload("res://Graphics/Player.png")
@onready var got_item_sprite = preload("res://Graphics/PlayerGetItem.png")
@onready var coat_arms_up_sprite = preload("res://Graphics/RainCoatArmsUp.png")
@onready var coat_sprite = preload("res://Graphics/Rain Coat.png")

@onready var clothing = $Sprites/Clothing
@onready var sun_hat = $"Sprites/Clothing/Sun Hat"
@onready var rain_coat = $"Sprites/Clothing/Rain Coat"
@onready var snow_boots = $"Sprites/Clothing/Snow Boots"

@onready var weather_handler = $"../WeatherHandler"
@onready var tilemap : TileMap = $"../TileMap"
@onready var game : Game = $".."
@onready var camera_2d = $Camera2D
@onready var attack_origin = $AttackOrigin
@onready var animation_player = $AnimationPlayer
@onready var player = $Sprites/Player
@onready var display_position = $Sprites/Display
@onready var damage_taker : Damage_Taker = $DamageTaker
@onready var get_item_sound = $GetItemSound
@onready var equip_item_sound = $EquipItemSound
@onready var footstepper = $Footstepper

var attack_timer = 0
var attacked = false

func _ready():
	
	# we must be testing from the editor
	if SaveHandler.game_save == null:
		print("Testing from the editor. Creating new save.")
		SaveHandler.create_new_save()
	
	if SaveHandler.game_save.has_respawn_position:
		# If we go to the menu and come back
		position = SaveHandler.game_save.respawn_position
		show_progress()
	else:
		SaveHandler.game_save.respawn_position = position
	
	get_tree().call_group("enemy", "player_spawned", self)

func _physics_process(delta):
	
	if SaveHandler.tutorial_finished == false or damage_taker.dead == true: return
	
	if Input.is_action_just_pressed("use"):
		attacked = true
	
	if attack_timer < ATTACK_DELAY:
		attack_timer += delta
	else:
		if attacked:
			attack(get_global_mouse_position())
			attack_timer = 0
			attacked = false
	
	var input = Vector2(Input.get_axis("left", "right"), Input.get_axis("up","down")).normalized()
	var next_position = (position + input.normalized()* SPEED * delta) 
	var can_move_there = can_move_to(next_position)
	
	if input != Vector2.ZERO:
		animation_player.play("move")
		if can_move_there:
			footstepper.moved(Utils.get_tile_at(next_position).footstep_sound)
	else:
		animation_player.play("idle")
	
#	if input.x < 0:
#		animation_player.flip_h = true
#	else:
#		animation_player.flip_h = false
	
	if can_move_there:
		velocity = input * SPEED
		move_and_slide()
	else:
		if SaveHandler.game_save.knows_about_climate == false and Utils.get_tile_at(next_position).name != "Water":
			Utils.show_message("I don't have the clothing to go there!", 4)
			SaveHandler.game_save.knows_about_climate = true

func can_move_to(pos : Vector2):
	var tile = Utils.get_tile_at(pos)
	
	if tile == null: return
	
	weather_handler.tried_stepping_on(tile)
	
	if tile.required_progress <= SaveHandler.game_save.progress:
		return true
	
	return false

func get_camera_size() -> Vector2:
	var canvas_trans = get_canvas_transform()
	var min_pos = -canvas_trans.get_origin() / canvas_trans.get_scale()
	var view_size = get_viewport_rect().size / canvas_trans.get_scale()
	var max_pos = min_pos + view_size
	return view_size

func attack(target_pos : Vector2):
	var normal = (target_pos - attack_origin.global_position).normalized()
	
	var instance : Attack = attack_scene.instantiate()
	
	var offset = minf(target_pos.distance_to(attack_origin.global_position), MAX_ATTACK_OFFSET)
	
	instance.position = attack_origin.global_position + (normal * offset)
	instance.setup(damage_taker)
	
#	if normal.x < 0:
#		instance.flip_h = true
	get_tree().root.add_child(instance)

func show_progress():
	var progress = SaveHandler.game_save.progress
	
	if progress >= 1:
		sun_hat.visible = true
	if progress >= 2:
		rain_coat.visible = true
	if progress >= 3:
		snow_boots.visible = true

func pickup_item(item : Item):
	SaveHandler.game_save.progress = item.progress
	var progress = SaveHandler.game_save.progress
	
	player.texture = got_item_sprite
	
	# if we have the coat
	if progress >= 2:
		rain_coat.texture = coat_arms_up_sprite
	
	Utils.show_message("I found " + str(item.name) + "!", 3)
	
	display_position.texture = item.outline_sprite
	get_item_sound.playing = true
	
	await (get_tree().create_timer(2).timeout)
	
	Utils.show_message(item.message_on_pickup, 3)
	
	# if we just completed the game
	if progress >= 4:
		await (get_tree().create_timer(3).timeout)
		Utils.complete_game()
		return
	
	equip_item_sound.playing = true
	display_position.texture = null
	clothing.get_child(SaveHandler.game_save.progress - 1).visible = true
	
	# if we have the coat
	if progress >= 2:
		rain_coat.texture = coat_sprite
	
	player.texture = idle_sprite

# when we die
func _on_damage_taker_died():
	animation_player.play("die")

func respawn():
	position = SaveHandler.game_save.respawn_position
	camera_2d.zoom = Vector2(2,2)
	
	# this is dumb.
	damage_taker.dead = false
	damage_taker.take_damage(-damage_taker.max_health)
