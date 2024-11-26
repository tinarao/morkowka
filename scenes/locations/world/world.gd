extends Node2D


@onready var Hills: TileMapLayer = $Hills
@onready var Objects: TileMapLayer = $Objects
@onready var Plows: TileMapLayer = $Plows
@onready var PlantedVeggies: TileMapLayer = $PlantedVeggies

const BASIC_BEETROOT_SPRITE_ATLAS = Vector2i(1, 1)

const HILLS_TILES_ALLOWED_TO_PLOW = [
	Vector2i(1, 1),
	Vector2i(0, 5),
	Vector2i(1, 5),
	Vector2i(2, 5),
	Vector2i(3, 5),
	Vector2i(4, 5),
	Vector2i(5, 5),
	Vector2i(0, 6),
	Vector2i(1, 6),
	Vector2i(2, 6),
	Vector2i(3, 6),
	Vector2i(4, 6),
	Vector2i(5, 6),
]

# Vector2i[]
var PLOWED_TILES = []

# Vector2i[]
var PLANTED_SEEDS = []

# Signals
signal plowed_successfully
signal planted_beetroot_successfully

func _on_player_can_plow() -> void:
	var mouse_pos = get_local_mouse_position()
	var tile_coordinates = Hills.local_to_map(mouse_pos)
	var tile_atlas_coordinates = Hills.get_cell_atlas_coords(tile_coordinates)
	if not HILLS_TILES_ALLOWED_TO_PLOW.has(tile_atlas_coordinates):
		return

	PLOWED_TILES.push_back(tile_coordinates)
	Plows.set_cells_terrain_connect(PLOWED_TILES, 0, 0, false) 
	plowed_successfully.emit()


func _on_player_can_plant_a_beetroot() -> void:
	var mouse_pos = get_local_mouse_position()
	var tile_coordinates = Plows.local_to_map(mouse_pos)
	var tile = Plows.get_cell_tile_data(tile_coordinates)

	if tile == null:
		return

	if PLANTED_SEEDS.has(tile_coordinates):
		return

	PLANTED_SEEDS.push_back(tile_coordinates)
	PlantedVeggies.set_cell(tile_coordinates, 0, BASIC_BEETROOT_SPRITE_ATLAS)
	
	planted_beetroot_successfully.emit()
