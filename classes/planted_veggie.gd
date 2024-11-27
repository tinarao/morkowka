class_name PlantedVeggie 

var stage: int = 1
var planted_at: int
var tile_coordinates: Vector2i
var atlas_coordinates: Vector2i
const MAXIMUM_STAGE = 4

func _init(p_tile_coordinates: Vector2i, p_atlas_coordinates: Vector2i) -> void:
    self.stage = 1
    self.atlas_coordinates = p_atlas_coordinates
    self.tile_coordinates = p_tile_coordinates

func increase_stage() -> void:
    if self.stage == MAXIMUM_STAGE:
        print("odna swekla sozrela!")
        return

    self.stage += 1