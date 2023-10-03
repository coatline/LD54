extends Node2D
@onready var restart_button = $CanvasLayer/RestartButton
@onready var view_story_button = $"CanvasLayer/View Story Button"

func _ready():
	if SaveHandler.viewed_cutscene == true and SaveHandler.game_save != null:
		view_story_button.visible = true
		restart_button.visible = true


func _on_restart_button_pressed():
	SaveHandler.create_new_save()
	get_tree().change_scene_to_file("res://game.tscn")

func _on_view_story_button_pressed():
	get_tree().change_scene_to_file("res://opening.tscn")


func _on_play_button_pressed():
	if SaveHandler.game_save == null:
		SaveHandler.create_new_save()
	
	if SaveHandler.viewed_cutscene == false:
		get_tree().change_scene_to_file("res://opening.tscn")
	else:
		get_tree().change_scene_to_file("res://game.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
