extends TileMap

const GROUND_LAYER = 0
const GRASS_LAYER = 1

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

	for layer in get_layers_count() - 1:
		var tile_data = get_cell_source_id(layer, tile_coordinates)
		if tile_data == -1:
			continue

		is_tile_exists = true

	if not is_tile_exists:
		print("No tile!")
		return

	var crop_atlas_pos: Vector2i = Vector2i(2, 6)
	set_cell(1, tile_coordinates, 3, crop_atlas_pos)
