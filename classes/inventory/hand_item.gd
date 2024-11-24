class_name HandItem

@export var public_name: String     # Семяна свеклы
@export var private_name: String    # beetroot_seeds
@export var amount: int             # 12

func _init(p_public_name: String, p_private_name: String, p_amount: int) -> void:
    self.public_name = p_public_name
    self.private_name = p_private_name
    self.amount = p_amount