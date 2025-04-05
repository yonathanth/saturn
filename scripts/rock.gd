extends RigidBody2D

var rock_textures = [
	preload("res://assets/rocks/rock1.png"),
	preload("res://assets/rocks/rock2.png"),
	preload("res://assets/rocks/rock3.png")
]

func _ready():
	# Randomize texture
	$Sprite2D.texture = rock_textures[randi() % rock_textures.size()]
	
	# Randomize scale
	var scale_factor = randf_range(0.055, 0.077)
	$Sprite2D.scale = Vector2(scale_factor, scale_factor)
	$CollisionShape2D.scale = Vector2(scale_factor, scale_factor)
	
	# Apply random initial impulse
	var random_x = randf_range(-100, 100)
	var random_y = randf_range(200, 400)
	apply_central_impulse(Vector2(random_x, random_y))
	angular_velocity = randf_range(-2, 2)

func _process(delta):
	if position.y > 1000:
		queue_free()
