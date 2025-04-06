# ice_collectable.gd
extends Area2D

@export var speed := 300.0
@export var y_variation := 80.0

func _ready():
	# Start moving left with slight vertical variation
	var move_tween = create_tween()
	move_tween.tween_property(self, "position", 
		Vector2(-100, position.y + randf_range(-y_variation, y_variation)), 
		5.0)
	move_tween.tween_callback(queue_free) 
