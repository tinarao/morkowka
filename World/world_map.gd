extends TileMap

const GROUND_LAYER: int = 0
const PLOWS_LAYER: int = 1
const PLANTS_LAYER: int = 2

@onready var player = get_parent().get_node("Player")

# Vector2i[]
var plowed_tiles = []

# Vector2i[]
var beetroot_planted_tiles = []

var avaliable_to_crop_tiles_atlas: Array = [
	Vector2i(1, 1),
	Vector2i(10, 4),

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

func _on_player_plow_signal() -> void:
	plow_a_tile()


# Actions

func plow_a_tile() -> void:
	var mouse_pos = get_local_mouse_position()
	var tile_coordinates: = local_to_map(mouse_pos)
	var tile_atlas_coordinates = get_cell_atlas_coords(0, tile_coordinates)

	if not avaliable_to_crop_tiles_atlas.has(tile_atlas_coordinates):
		return

	plowed_tiles.push_back(tile_coordinates)
	set_cells_terrain_connect(PLOWS_LAYER, plowed_tiles, 0, 1, false) 

func plant_beetroot() -> void:
	var mouse_pos = get_local_mouse_position()
	var tile_coordinates: = local_to_map(mouse_pos)

	if not plowed_tiles.has(tile_coordinates):
		print("can't plant on not plowed tile")
		return

	if beetroot_planted_tiles.has(tile_coordinates):
		print("beetroot is already planted here")
		return

	beetroot_planted_tiles.push_back(tile_coordinates)
	var plant_atlas_coords: Vector2i = Vector2i(1, 1)
	set_cell(PLANTS_LAYER, tile_coordinates, 3, plant_atlas_coords)

func _on_player_plant_beetroot_signal() -> void:
	plant_beetroot()
