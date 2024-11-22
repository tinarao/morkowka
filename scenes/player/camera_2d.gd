extends Camera2D

const ZOOM_MAX: int = 5
const ZOOM_MIN: int = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_mousewheel_down") && zoom.x >= ZOOM_MIN:
		zoom.x -= 0.2
		zoom.y -= 0.2

	if Input.is_action_just_pressed("ui_mousewheel_up") && zoom.x <= ZOOM_MAX:
		zoom.x += 0.2
		zoom.y += 0.2
