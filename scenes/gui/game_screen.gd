extends CanvasLayer

@onready var player = get_parent().get_node("Player")

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	$SelectedItemLabel.text = "Selected item: " + player.selected_item_label
	$BeetrootSeedsLabel.text = "Beetroot seeds amount: " + str(player.seeds["beetroot"])


func _on_day_night_modulator_time_tick(day: int, hour: int, _minute: int) -> void:
	$DayLabel.text = "Day: %d\nHour: %d" % [day, hour]
