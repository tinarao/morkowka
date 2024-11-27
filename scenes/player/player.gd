extends CharacterBody2D


const SPEED = 100.0

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
	0: "empty",
	1: "beetroot_seeds",
	2: "hoe",
}

var selected_item: HandItems = HandItems.Empty
var selected_item_label: String = hand_items_labels[selected_item]

@onready var anim_tree: AnimationTree = $AnimationTree
@onready var Torch: PointLight2D = $Torch
var latest_facing_direction: Vector2 = Vector2(0, 0)
var plowing: bool = false


signal can_plow
signal can_plant_a_beetroot


func _ready() -> void:
	Torch.enabled = false
	anim_tree.active = true
	seeds["beetroot"] = 9

func _process(_delta: float) -> void:
	selected_item_label = hand_items_labels[selected_item]

func _physics_process(_delta: float) -> void:
	handle_animations()
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

	if Input.is_action_just_pressed("ui_torch"):
		Torch.set("enabled", !Torch.enabled)

	if Input.is_action_just_pressed("action"):
		match selected_item:
			HandItems.Hoe:
				plow()
			HandItems.BeetrootSeeds:
				plant_a_beetroot()
	else:
		plowing = false

func handle_animations() -> void:
	var idle = velocity == Vector2.ZERO
	if !idle:
		latest_facing_direction = velocity.normalized()

	anim_tree.set("parameters/Idle/blend_position", latest_facing_direction)
	anim_tree.set("parameters/Walk/blend_position", latest_facing_direction)
	anim_tree.set("parameters/Plow/blend_position", latest_facing_direction)

# Actions

# Plow
func plow() -> void:
	can_plow.emit()
	
func _on_world_layers_plowed_successfully() -> void:
	plowing = true

# Beetroot plant
func plant_a_beetroot() -> void:
	if seeds["beetroot"] > 0:
		can_plant_a_beetroot.emit()

func _on_world_layers_planted_beetroot_successfully() -> void:
	seeds["beetroot"] = seeds["beetroot"] - 1