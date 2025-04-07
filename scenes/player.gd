
extends CharacterBody2D
# movement
# Movement settings
@export var move_speed := 300.0
@export var screen_padding := 30.0  # Distance from edge


# shooting settings
# At top with other @exports
@export var bullet_scene: PackedScene
@export var fire_rate := 0.15  # Seconds between shots
@export var bullet_spawn_distance := 50.0  # Pixels in front of ship

# Health System settings
@export var max_health := 10
var current_health: float
var is_invulnerable := false  # For temporary immunity after hit



# Add to your existing variables at the top
@export var rock_damage_scale := 0.5  # Damage multiplier based on rock size
@export var ice_heal_amount := 1      # Health restored from ice
var last_collision_time := 0.0        # For collision cooldown
@export var collision_cooldown := 0.5 # Seconds between collision checks



# Distance tracking
# @export var target_distance := 5000.0  # Distance to travel to win (in pixels)
# var distance_covered := 0.0            # Total distance traveled
# var previous_position: Vector2         # To calculate distance per frame

# UI reference
@onready var distance_label = get_node("res://scenes/main_game_play.tscn/CanvasLayer/Label") as Label
@export var target_time := 30.0  # target survival time in seconds
var elapsed_time := 0.0  # tracks time passed
var fake_distance_per_second := 100.0
@onready var time_label = get_node("CanvasLayer/Label") as Label



# movement related functions
func _physics_process(delta):
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_dir * move_speed
	apply_screen_boundaries()
	
	# Detect collisions when moving
	var collision = move_and_collide(velocity * delta)
	if collision:
		handle_collision(collision.get_collider())
		
	
	move_and_slide()
	# Increment elapsed time
	elapsed_time += delta

	# Calculate fake distance based on elapsed time
	var fake_distance = elapsed_time * fake_distance_per_second

	# Update UI with fake distance
	if time_label:
		time_label.text = "Distance: %.0f units" % fake_distance

	# Check if target time is reached
	if elapsed_time >= target_time:
		trigger_success_scene()
	
	
	
	
func apply_screen_boundaries():
	var viewport = get_viewport_rect().size
	global_position = global_position.clamp(
		Vector2(screen_padding, screen_padding),
		Vector2(viewport.x - screen_padding, viewport.y - screen_padding)
	)




func trigger_success_scene():
	# Load and change to the success scene
	get_tree().change_scene_to_file("res://scenes/success_scene.tscn")
	# Inside _physics_process, after updating distance_covered











# shooting
var can_shoot := true
var shoot_timer: Timer

func _ready():
	# Set up shooting timer
	add_to_group("player")
	shoot_timer = Timer.new()
	add_child(shoot_timer)
	shoot_timer.one_shot = true
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	
	# health
	current_health = max_health
	$IceDetector.area_entered.connect(_on_ice_collected)  # Detect Area2D collisions (ice)
	# Initialize elapsed time
	elapsed_time = 0.0


# New function to handle ice collection
func _on_ice_collected(area):
	if area.is_in_group("ice"):
		print("yuppie")
		handle_ice_collision(area)  # Reuse your existing ice-handling function
		
	

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
	


func _input(event):
	# Press T key to test explosion at player position
	if event.is_action_pressed("ui_paste"):  # Default T ke
		die()
		
# health

func take_damage(amount: float):
	if is_invulnerable:
		return
	
	current_health -= amount
	print("Player hit! Health: ", current_health, " (Lost ", amount, " HP)")
	
	# Visual feedback
	$ShipSprite.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$ShipSprite.modulate = Color.WHITE
	
	# Temporary invulnerability
	is_invulnerable = true
	await get_tree().create_timer(1.0).timeout
	is_invulnerable = false
	
	if current_health <= 0:
		die()

func die():
	# Spawn explosion before removing player
	var explosion = preload("res://scenes/explosion.tscn").instantiate()
	explosion.global_position = global_position
	# queue_free()
	get_parent().add_child(explosion)
	await get_tree().create_timer(0.9).timeout
	print("trans zitionnnnnnnnnnnnnnn")
	get_tree().change_scene_to_file("res://scenes/failure_scene.tscn")
	print("Transitioning to failure scene!")
	# Wait briefly for explosion to be visible (optional)
	
# Remove the player immediately
	queue_free()
	
	# Create a timer and wait for it in a separate coroutine
	


	

# Add this function to handle collisions

		
func handle_collision(collider):
	var current_time = Time.get_ticks_msec() / 1000.0
	
	# Prevent rapid repeated collisions
	if current_time - last_collision_time < collision_cooldown:
		return
	
	last_collision_time = current_time
	
	# Check if collider is in a group
	if collider.is_in_group("rocks"):
		handle_rock_collision(collider)
	

func handle_rock_collision(rock):
	# Calculate damage based on rock size (bigger rocks hurt more)
	var size_ratio = rock.current_scale / rock.big_size
	var damage = (size_ratio / rock_damage_scale)
	print(damage)
	take_damage(damage)
	
	# Small knockback effect
	var knockback_dir = (global_position - rock.global_position).normalized()
	velocity = knockback_dir * move_speed * 0.3

func handle_ice_collision(ice):
	# Heal player
	current_health = min(current_health + ice_heal_amount, max_health)
	print("Health restored! Current: ", current_health)
	
	# Visual feedback
	$ShipSprite.modulate = Color.GREEN
	await get_tree().create_timer(0.1).timeout
	$ShipSprite.modulate = Color.WHITE
	
	# Remove the ice
	ice.queue_free()











func _on_shoot_timer_timeout():
	can_shoot = true
