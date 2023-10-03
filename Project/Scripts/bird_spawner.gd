extends Node

const MAX_BIRDS = 10
const TIME_BETWEEN_SPAWNS = 3

@onready var bird_scene := preload("res://bird.tscn")
@onready var player : Player = $"../Player"
@onready var timer = $Timer
var camera_size : Vector2

func _ready():
	timer.wait_time = TIME_BETWEEN_SPAWNS
	timer.timeout.connect(try_create_bird)
	
	camera_size = player.get_camera_size()

func try_create_bird():
	if player == null: return
	
	if get_child_count() < MAX_BIRDS:
		create_bird_rand()


func create_bird_rand():
	var min_offset_x = -camera_size.x
	var max_offset_x = -camera_size.x / 2
	var min_offset_y = -camera_size.y
	var max_offset_y = -camera_size.y / 2
	
	var rand = randi_range(0, 7)
	
	match rand:
		1:
			#010
			#0x0
			#000
			min_offset_x = -camera_size.x / 2
			max_offset_x = camera_size.x / 2
		2:
			#001
			#0x0
			#000
			min_offset_x = camera_size.x / 2
			max_offset_x = camera_size.x
		3:
			#000
			#1x0
			#000
			min_offset_y = - camera_size.y / 2
			max_offset_y = camera_size.y / 2
		4:
			#000
			#0x1
			#000
			min_offset_x = camera_size.x / 2
			max_offset_x = camera_size.x
			
			min_offset_y = - camera_size.y / 2
			max_offset_y = camera_size.y / 2
		5:
			#000
			#0x0
			#100
			min_offset_y = camera_size.y / 2
			max_offset_y = camera_size.y
		6:
			#000
			#0x0
			#010
			min_offset_x = -camera_size.x / 2
			max_offset_x = camera_size.x / 2
			
			min_offset_y = camera_size.y / 2
			max_offset_y = camera_size.y
		7:
			#000
			#0x0
			#001
			min_offset_x = camera_size.x / 2
			max_offset_x = camera_size.x
			
			min_offset_y = camera_size.y / 2
			max_offset_y = camera_size.y
	
	var pos = player.position + Vector2(randf_range(min_offset_x, max_offset_x), randf_range(min_offset_y, max_offset_y))
	
	if Utils.get_tile_at(pos) == null:
		return
	
	create_bird(pos)

func create_bird(pos : Vector2):
	var instance : Bird = bird_scene.instantiate()
	instance.position = pos
	
	var flying = false
	
	if player.position.y - (camera_size.y / 2) < pos.y and randf() < 0.6:
		flying = true
	
	if Utils.get_tile_at(pos).name == "Water":
		flying = true
	
	instance.setup(player, flying)
	add_child(instance)
