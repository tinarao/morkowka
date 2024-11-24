extends CharacterBody2D


const SPEED = 100.0
var anim_name: String

enum State {
	Idle,
	Walk,
	Plow,
	Seeding
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
	2: "plow",
	3: "seeding"
}

@onready var action_timer: Timer = $ActionTimer

var direction: Direction = Direction.Down
var state: State = State.Idle
var move_vec: Vector2 = Vector2.ZERO
var is_action: bool = false

var seeds: Dictionary = {
	"beetroot": 0
}

enum HandItems {
	Empty,
	BeetrootSeeds,
	Hoe,
}

var hand_items_labels = {
	1: "beetroot_seeds",
	2: "hoe",
	0: "empty"
}

var selected_item: HandItems = HandItems.Empty
var selected_item_label: String = hand_items_labels[selected_item]

func _ready() -> void:
	seeds["beetroot"] = 8
	pass

func _process(_delta: float) -> void:
	selected_item_label = hand_items_labels[selected_item]

	handle_controls()
	handle_directions()
	handle_states()
	handle_animations()

func _physics_process(_delta: float) -> void:
	handle_movement()
	move_and_slide()

func handle_movement() -> void:
	move_vec = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = move_vec * SPEED

func handle_controls() -> void:
	if Input.is_action_just_pressed("ui_mouse_leftclick"):
		is_action = true
		action_timer.start()

func _input(event: InputEvent) -> void:
	if event.as_text() == "0":
		selected_item = HandItems.Empty
	elif event.as_text() == "1":
		selected_item = HandItems.Hoe
	elif event.as_text() == "2":
		selected_item = HandItems.BeetrootSeeds

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
	if is_action and selected_item == HandItems.Hoe:
		state = State.Plow
		return

	if is_action and selected_item == HandItems.BeetrootSeeds:
		state = State.Seeding
		seeds["beetroot"] = seeds["beetroot"] - 1
		return

	if move_vec == Vector2.ZERO:
		state = State.Idle
	else:
		state = State.Walk

func handle_animations() -> void:
	anim_name = "%s_%s" % [stateDict[state], directionDict[direction]]
	$AnimatedSprite2D.play(anim_name)

func _on_action_timer_timeout() -> void:
	print("Action timer is timeouyt")
	is_action = false
	pass # Replace with function body.
