extends Resource

class_name Inventory

var allowed_items: Array = [
    "beetroot_seeds"
]

@export var items: Array = []

func add_item(item_name: String) -> void:
    assert(allowed_items.has(item_name))
    items.push_back(item_name)

func get_items() -> Array:
    return items

func get_item_amount(item_name: String) -> int:
    assert(allowed_items.has(item_name))
    return items.count(item_name)