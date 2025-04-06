extends Area2D


@export var speed := 800.0
@export var max_distance := 1000.0
var direction := Vector2.ZERO
var distance_traveled := 0.0



func _physics_process(delta):
	var movement = direction * speed * delta
	position += movement
	distance_traveled += movement.length()
	
	if distance_traveled > max_distance:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("asteroids"):
		body.destroy()
	queue_free()
