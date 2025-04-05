
extends CharacterBody2D

# Movement settings
@export var max_speed := 400.0
@export var acceleration := 150.0
@export var rotation_speed := 3.5  # Radians per second
@export var drag_factor := 0.98    # Slowdown when not thrusting


# At top with other @exports
@export var bullet_scene: PackedScene
@export var fire_rate := 0.15  # Seconds between shots
@export var bullet_spawn_distance := 50.0  # Pixels in front of ship











var current_speed := 0.0
var direction := Vector2.ZERO

func _physics_process(delta):
	handle_rotation(delta)
	handle_thrust()
	apply_movement()

func handle_rotation(delta):
	var rotate_dir = Input.get_axis("ui_left", "ui_right")
	rotation += rotate_dir * rotation_speed * delta

func handle_thrust():
	if Input.is_action_pressed("ui_up"):
		current_speed = min(current_speed + acceleration, max_speed)
		direction = Vector2(cos(rotation), sin(rotation))
	else:
		current_speed *= drag_factor  # Gradual slowdown

func apply_movement():
	velocity = direction * current_speed
	move_and_slide()




var can_shoot := true
var shoot_timer: Timer

func _ready():
	# Set up shooting timer
	shoot_timer = Timer.new()
	add_child(shoot_timer)
	shoot_timer.one_shot = true
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)

func _process(delta):
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()

func shoot():
	if bullet_scene == null:
		return
	
	var bullet = bullet_scene.instantiate()
	
	# Position bullet in front of ship
	var forward = Vector2(cos(rotation), sin(rotation))
	bullet.global_position = global_position + forward * bullet_spawn_distance
	bullet.direction = forward
	bullet.rotation = rotation
	
	# Add to scene
	get_parent().add_child(bullet)
	
	# Start cooldown
	can_shoot = false
	shoot_timer.start(fire_rate)

func _on_shoot_timer_timeout():
	can_shoot = true
