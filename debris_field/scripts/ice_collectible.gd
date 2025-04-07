extends RigidBody2D

@export var speed: float = 300.0
@export var y_variation: float = 80.0

func _ready() -> void:
	add_to_group("ice")
	body_entered.connect(_on_body_entered)
	var move_tween: Tween = create_tween()
	move_tween.tween_property(self, "position", 
		Vector2(-100, position.y + randf_range(-y_variation, y_variation)), 5.0)
	move_tween.tween_callback(queue_free)

func _on_body_entered(body: Node) -> void:
	print("Confirmation on this side of contact")
