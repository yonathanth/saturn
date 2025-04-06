

extends Node2D

@export var RockScene: PackedScene = preload("res://scenes/rock.tscn")
@export var IceScene: PackedScene = preload("res://scenes/ice_collectable.tscn")
var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")  
var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height") 
@onready var spawn_timer = $Timer 

func _ready():
	
	if not spawn_timer.timeout.is_connected(_on_timer_timeout):
		spawn_timer.timeout.connect(_on_timer_timeout)
	# Decrease the spawn interval (e.g., every 0.5 to 1.5 seconds)
	spawn_timer.wait_time = randf_range(0.5, 1.5)
	spawn_timer.start()

func _on_timer_timeout():
	if randf() > 0.2:
		spawn_rock()
	else:
		spawn_ice()
	# Reset timer with shorter interval
	spawn_timer.wait_time = randf_range(0.5, 1.5)

func spawn_rock():
	var rock = RockScene.instantiate()
	# Spawn at right edge, random y position
	rock.position = Vector2(screen_width + 50, randf_range(0, screen_height))
	# Apply leftward force instead of downward
	rock.apply_central_impulse(Vector2(randf_range(-400, -200), randf_range(-100, 100)))
	rock.angular_velocity = randf_range(-2, 2)  # Random rotation
	add_child(rock)

func spawn_ice():
	var ice = IceScene.instantiate()
	ice.position = Vector2(screen_width + 50, randf_range(0, screen_height))
	
	# For RigidBody2D version:
	if ice is RigidBody2D:
		ice.apply_central_impulse(Vector2(randf_range(-400, -200), randf_range(-100, 100)))
	
	add_child(ice)
