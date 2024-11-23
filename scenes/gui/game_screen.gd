extends CanvasLayer

@onready var player = get_parent().get_node("Player")

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	var br_seeds = str(player.seeds["beetroot"])
	$BeetrootSeeds.text = "beetroot_seeds: " + br_seeds
