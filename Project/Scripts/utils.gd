extends Node

var tiles = [preload("res://Resources/Tiles/Dirt.tres"), 
preload("res://Resources/Tiles/Grass.tres"), 
preload("res://Resources/Tiles/Rain.tres"), 
preload("res://Resources/Tiles/Sand.tres"),
 preload("res://Resources/Tiles/Snow.tres"), 
preload("res://Resources/Tiles/Water.tres")]


func tile_from_atlas(atlas_coords : Vector2i):
	for tile in tiles:
		if tile.atlas_coords == atlas_coords:
			return tile
	
	assert(false,"The following atlas coords couldn't be found: " + str(atlas_coords))
	return null

var tilemap : TileMap = null

func get_tile_at(world_position : Vector2):
	var cell_position = tilemap.local_to_map(world_position)
	var tile_data = tilemap.get_cell_tile_data(0, cell_position)
	
	if tile_data == null:
		return null
	
	var atlas_coords = tilemap.get_cell_atlas_coords(0, cell_position)
	var tile : Tile = tile_from_atlas(atlas_coords)
	return tile

signal display_message(String, float)

func show_message(message : String, time : float):
	display_message.emit(message, time)

signal game_completed

func complete_game():
	game_completed.emit()
