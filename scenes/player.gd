
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
@export var max_health := 3
var current_health: int
var is_invulnerable := false  # For temporary immunity after hit



# movement related functions
func _physics_process(delta):
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_dir * move_speed
	apply_screen_boundaries()
	move_and_slide()

func apply_screen_boundaries():
	var viewport = get_viewport_rect().size
	global_position = global_position.clamp(
		Vector2(screen_padding, screen_padding),
		Vector2(viewport.x - screen_padding, viewport.y - screen_padding)
	)















# shooting
var can_shoot := true
var shoot_timer: Timer

func _ready():
	# Set up shooting timer
	shoot_timer = Timer.new()
	add_child(shoot_timer)
	shoot_timer.one_shot = true
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	
	# health
	current_health = max_health

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

func take_damage(amount: int):
	if is_invulnerable:
		return
	
	current_health -= amount
	print("Player health: ", current_health)
	
	# Flash effect (optional)
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
	queue_free()
	get_parent().add_child(explosion)
	
	  # Remove player

func _on_shoot_timer_timeout():
	can_shoot = true
