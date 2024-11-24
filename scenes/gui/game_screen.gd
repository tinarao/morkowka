extends CanvasLayer

@onready var player = get_parent().get_node("Player")

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	$SelectedItemLabel.text = "Selected item: " + player.selected_item_label
	$BeetrootSeedsLabel.text = "Beetroot seeds amount: " + str(player.seeds["beetroot"])
