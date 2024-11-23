extends TileMap

const GROUND_LAYER = 0
const GRASS_LAYER = 1

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

# (0,5) -> (5,5)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_mouse_leftclick"):
		plow_a_tile()


func plow_a_tile():
	# Gets tile position
	# Plows it

	var mouse_pos = get_local_mouse_position()
	var tile_coordinates = local_to_map(mouse_pos)
	var is_tile_exists: bool = false

	var goal_layer: int = 0
	for layer in get_layers_count() - 3:
		var tile_data = get_cell_source_id(layer, tile_coordinates)
		if tile_data == -1:
			continue

		is_tile_exists = true
		goal_layer = layer

	if not is_tile_exists:
		print("no tile")
		return

	var tile_atlas_coordinates = get_cell_atlas_coords(goal_layer, tile_coordinates)
	if not avaliable_to_crop_tiles_atlas.has(tile_atlas_coordinates):
		print("can't plow this tile")
		return

	var crop_atlas_pos: Vector2i = Vector2i(2, 6)
	set_cell(1, tile_coordinates, 3, crop_atlas_pos)
