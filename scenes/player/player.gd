extends CharacterBody2D


const SPEED = 150.0

enum State {
	Idle,
	Walk,
}

enum Direction {
	Left,
	Right,
	Up,
	Down
}

var directionDict: Dictionary = {
	0: "left",
	1: "right",
	2: "up",
	3: "down"
}

var stateDict: Dictionary = {
	0: "idle",
	1: "walk",
}

var direction: Direction = Direction.Down
var state: State = State.Idle

var anim_name: String

func _process(_delta: float) -> void:
	handle_directions()
	handle_states()
	handle_animations()

func _physics_process(_delta: float) -> void:
	handle_movement()
	move_and_slide()

func handle_movement() -> void:
	var move_vec = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = move_vec * SPEED

func handle_directions() -> void:
	if Input.is_action_just_pressed("ui_left"):
		direction = Direction.Left

	if Input.is_action_just_pressed("ui_right"):
		direction = Direction.Right

	if Input.is_action_just_pressed("ui_up"):
		direction = Direction.Up

	if Input.is_action_just_pressed("ui_down"):
		direction = Direction.Down

func handle_states() -> void:
	var move_vec = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if move_vec == Vector2.ZERO:
		state = State.Idle
	else:
		state = State.Walk

func handle_animations() -> void:
	anim_name = "%s_%s" % [stateDict[state], directionDict[direction]]
	$AnimatedSprite2D.play(anim_name)