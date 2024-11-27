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

# PlantedVeggie[]
var planted_veggies = []

# Signals
signal plowed_successfully
signal planted_beetroot_successfully
signal plant_removed(seeds_to_return: int)

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

	var new_planted_veggie = PlantedVeggie.new(tile_coordinates, BASIC_BEETROOT_SPRITE_ATLAS)

	var is_err: bool = false
	for veg in planted_veggies:
		if veg.tile_coordinates == tile_coordinates:
			is_err = true
			break

	if is_err: 
		return

	planted_veggies.push_back(new_planted_veggie)
	PlantedVeggies.set_cell(tile_coordinates, 0, BASIC_BEETROOT_SPRITE_ATLAS)
	
	planted_beetroot_successfully.emit()

func _on_day_night_modulator_day_tick(_day: int, _elapsed_minutes: int) -> void:
	for n in range(len(planted_veggies)):
		var coinflip = randi() % 61
		if coinflip > 47:
			if planted_veggies[n].atlas_coordinates == Vector2i(4, 1):
				return

			var new_atlas = Vector2i(
				planted_veggies[n].atlas_coordinates.x + 1,
				planted_veggies[n].atlas_coordinates.y
			)
			planted_veggies[n].atlas_coordinates = new_atlas
			PlantedVeggies.set_cell(planted_veggies[n].tile_coordinates, 0, new_atlas)

func _on_player_remove_plant() -> void:
	var mouse_pos = get_local_mouse_position()
	var tile_coordinates = Plows.local_to_map(mouse_pos)
	var tile = Plows.get_cell_tile_data(tile_coordinates)

	if tile == null:
		return

	for veggie in planted_veggies:
		if veggie.tile_coordinates == tile_coordinates:
			PlantedVeggies.set_cell(veggie.tile_coordinates, -1)
			planted_veggies.remove_at(planted_veggies.find(veggie, 0))

			if veggie.atlas_coordinates == Vector2i(4, 0) or veggie.atlas_coordinates == Vector2i(4, 1):
				var seeds_to_return_amount = randi() % 3
				plant_removed.emit(2 + seeds_to_return_amount)
				return

			plant_removed.emit(1)
			