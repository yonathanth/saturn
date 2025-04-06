extends RigidBody2D

@export var min_size := 0.2
@export var split_scale_factor := 0.6
@export var initial_scale := 1.0
@export var move_speed := Vector2(-500, 0)  # Base leftward velocity
@export var random_impulse := Vector2(100, 100)  # Randomness range

var current_scale := 1.0

func _ready():
	$Sprite2D.texture = preload("res://assets/rocks/rock.png")
	gravity_scale = 0
	freeze = true  # Temporarily freeze for setup
	set_rock_scale(initial_scale)
	
	# Calculate movement with controlled leftward bias
	var movement = Vector2(
		move_speed.x + randf_range(-random_impulse.x, random_impulse.x),
		move_speed.y + randf_range(-random_impulse.y, random_impulse.y)
	)
	
	linear_velocity = movement  # Direct velocity control
	angular_velocity = randf_range(-2, 2)
	freeze = false  # Unfreeze after setup

func _process(delta):
	if position.x < -100:
		queue_free()

func set_rock_scale(new_scale: float):
	current_scale = new_scale
	var scale_vec = Vector2(current_scale, current_scale)
	$Sprite2D.scale = scale_vec
	$CollisionShape2D.scale = scale_vec
	mass = 1.0 / current_scale  # Adjust mass based on size


func destroy():
	# Split or disappear based on size
	if current_scale * split_scale_factor > min_size:
		split()
	else:
		# Create small explosion effect when disappearing
		var explosion = preload("res://scenes/explosion.tscn").instantiate()
		explosion.position = position
		get_parent().add_child(explosion)
	queue_free()

func split():
	# Create two smaller rocks
	for i in range(2):
		var small_rock = load("res://scenes/rock.tscn").instantiate()
		
		# Configure the new rock
		var new_scale = current_scale * split_scale_factor
		small_rock.initial_scale = new_scale
		
		# Position with offset
		var offset = Vector2(randf_range(-30, 30), randf_range(-30, 30))
		small_rock.position = position + offset
		
		# Add to scene
		get_parent().add_child(small_rock)
		
		# Apply explosive force
		var force_dir = Vector2(randf_range(-1, 1), randf_range(-0.5, 1)).normalized()
		var force_magnitude = 150 * (1.0 + (1.0 - new_scale))  # Stronger force for smaller rocks
		small_rock.apply_central_impulse(force_dir * force_magnitude)
		small_rock.angular_velocity = randf_range(-3, 3)  # Faster spin for smaller rocks
