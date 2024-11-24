extends CharacterBody2D


const SPEED = 100.0
var anim_name: String

var move_vec: Vector2 = Vector2.ZERO

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

@onready var anim_tree: AnimationTree = $AnimationTree

# Signals
signal plow_signal
signal plant_beetroot_signal

func _ready() -> void:
	anim_tree.active = true
	seeds["beetroot"] = 8

func _process(_delta: float) -> void:
	handle_animations()

func _physics_process(_delta: float) -> void:
	selected_item_label = hand_items_labels[selected_item]

	handle_movement()
	move_and_slide()

func handle_movement() -> void:
	move_vec = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	velocity = move_vec * SPEED

func _input(event: InputEvent) -> void:
	if event.as_text() == "0":
		selected_item = HandItems.Empty
	elif event.as_text() == "1":
		selected_item = HandItems.Hoe
	elif event.as_text() == "2":
		selected_item = HandItems.BeetrootSeeds

	if Input.is_action_just_pressed("action"):
		handle_actions()

func handle_animations() -> void:
	anim_tree.set("parameters/conditions/is_idle", velocity == Vector2.ZERO)
	anim_tree.set("parameters/conditions/is_moving", velocity != Vector2.ZERO)

	anim_tree.set("parameters/action/blend_position", move_vec)
	anim_tree.set("parameters/idle/blend_position", move_vec)
	anim_tree.set("parameters/move/blend_position", move_vec)

	if Input.is_action_just_pressed("action"):
		anim_tree.set("parameters/conditions/action", true)
	else:
		anim_tree.set("parameters/conditions/action", false)

func handle_actions() -> void:
	match selected_item:
		HandItems.Hoe:
			plow()
		HandItems.BeetrootSeeds:
			plant_beetroot()

# 
# Actions
# 

func plow() -> void:
	plow_signal.emit()

func plant_beetroot() -> void:
	plant_beetroot_signal.emit()