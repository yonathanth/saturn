extends Area2D

@export var speed := 300.0
@export var y_variation := 80.0

func _ready():
	# Add to ice group
	add_to_group("ice")
	
	# Connect signal
	body_entered.connect(_on_body_entered)
	
	# Movement (keep your existing tween)
	var move_tween = create_tween()
	move_tween.tween_property(self, "position", 
		Vector2(-100, position.y + randf_range(-y_variation, y_variation)), 
		5.0)
	move_tween.tween_callback(queue_free)

func _on_body_entered(body):
	print("so confirmation on this side of conatac")
