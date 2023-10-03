extends Node2D
class_name Game

@onready var tilemap = $TileMap
@onready var player = $Player
@onready var pause_menu = $CanvasLayer/PauseMenu
@onready var end_game_visual : TextureRect = $CanvasLayer/EndVisual
var gameover = false

func _ready():
	Utils.game_completed.connect(end_game)
	Utils.tilemap = tilemap
	
	if SaveHandler.tutorial_finished == false:
		do_opening_speech()

func _process(delta):
	
	if gameover:
		if end_game_visual.modulate.a < 1:
			end_game_visual.modulate.a += delta
		else:
			get_tree().change_scene_to_file("res://end_visual.tscn")
	
	if Input.is_action_just_pressed("cheats"):
		SaveHandler.game_save.progress = 4
	
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	
	if Input.is_action_just_pressed("ui_cancel"):
		pause_menu.visible = true
		get_tree().paused = true
	
	if Input.is_action_just_pressed("skip"):
		SaveHandler.tutorial_finished = true

func do_opening_speech():
	Utils.show_message("Where am I?", 2)
	await(get_tree().create_timer(2).timeout)
	
	Utils.show_message("I can't remember anything!", 2)
	await(get_tree().create_timer(2).timeout)
	
	Utils.show_message("Well, other than the letters: 'W', 'A', 'S', and 'D'.", 3)
	await(get_tree().create_timer(3).timeout)
	
	Utils.show_message("And something about a left mouse button??", 3.75)
	await(get_tree().create_timer(4).timeout)
	
	Utils.show_message("What is wrong with me.", 1)
	await(get_tree().create_timer(1.5).timeout)
	
	SaveHandler.tutorial_finished = true
	
	Utils.show_message("Anyways, I better look around.", 1.5)
	await(get_tree().create_timer(1.5).timeout)
	
	Utils.show_message("I hope I'm dressed for the climate around here.", 3.5)


func end_game():
	gameover = true
	end_game_visual.visible = true

func _on_continue_pressed():
	print("Sdf")
	pause_menu.visible = false
	get_tree().paused = false

func _on_menu_pressed():
	print("SdfSDF")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main.tscn")
