# bullet.gd
extends Area2D

@export var speed := 800.0
@export var max_distance := 1000.0
var direction := Vector2.ZERO
var distance_traveled := 0.0

# bullet.gd
func _ready():
	# Connect the area entered signal if not done in editor
	body_entered.connect(_on_body_entered)
	
func _physics_process(delta):
	var movement = direction * speed * delta
	position += movement
	distance_traveled += movement.length()
	
	if distance_traveled > max_distance:
		queue_free()

# bullet.gd
func _on_body_entered(body):
	if body.is_in_group("player"):
		return  # Ignore collisions with player
	
	if body.is_in_group("asteroids"):
		body.destroy()
	queue_free()
