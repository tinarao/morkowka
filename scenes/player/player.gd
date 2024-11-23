extends CharacterBody2D


const SPEED = 100.0
var anim_name: String

enum State {
	Idle,
	Walk,
	TreeChop
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
	2: "treechop",
}

@onready var action_timer: Timer = $ActionTimer

var inventory: Inventory
var direction: Direction = Direction.Down
var state: State = State.Idle
var move_vec: Vector2 = Vector2.ZERO
var is_action: bool = false

var seeds: Dictionary = {
	"beetroot": 0
}

func _ready() -> void:
	inventory = Inventory.new()
	for n in 8:
		inventory.add_item("beetroot_seeds")

func _process(_delta: float) -> void:
	seeds["beetroot"] = inventory.items.count("beetroot_seeds")

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
	if is_action:
		state = State.TreeChop
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
