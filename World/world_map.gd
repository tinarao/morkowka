extends TileMap

const GROUND_LAYER: int = 0
const GRASS_LAYER: int = 1
const PLOWS_LAYER: int = 2

@onready var player = get_parent().get_node("Player")

# Vector2i[]
var plowed_tiles = []

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

func plow_a_tile():
	var mouse_pos = get_local_mouse_position()
	var tile_coordinates: = local_to_map(mouse_pos)
	var is_tile_exists: bool = false

	var goal_layer: int = 0
	for layer in get_layers_count() - 3:
		var tile_data = get_cell_source_id(layer, tile_coordinates)
		if tile_data == -1:
			continue

		is_tile_exists = true
		
	if not is_tile_exists:
		return

	var tile_atlas_coordinates = get_cell_atlas_coords(goal_layer, tile_coordinates)
	if not avaliable_to_crop_tiles_atlas.has(tile_atlas_coordinates):
		return

	var crop_atlas_pos: Vector2i = Vector2i(1, 1)
	plowed_tiles.push_back(tile_coordinates)
	set_cell(PLOWS_LAYER, tile_coordinates, 3, crop_atlas_pos)
	set_cells_terrain_connect(PLOWS_LAYER, plowed_tiles, 0, 1, false)

func _on_player_plow_signal() -> void:
	plow_a_tile()
