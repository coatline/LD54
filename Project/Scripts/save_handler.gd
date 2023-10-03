extends Node

var game_save : GameSave = null

var viewed_cutscene = false
var tutorial_finished = false

func create_new_save():
	game_save = GameSave.new()

func save(player_pos : Vector2):
	game_save.respawn_position = player_pos
	game_save.has_respawn_position = true

func delete_save():
	game_save = null
