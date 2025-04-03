extends CharacterBody2D

@export var laser_scene: PackedScene

@export var speed := 300.0
@export var boost_speed := 500.0
var health := 3
var shield_active := false

func _physics_process(delta: float) -> void:
	# Input for steering
	var direction := Vector2.ZERO
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")

	# Boost
	var current_speed := boost_speed if Input.is_action_just_pressed("boost") else speed
	velocity = direction.normalized() * current_speed

	# Move the ship
	move_and_slide()
	
	
	
	if Input.is_action_just_pressed("shoot") and $LaserGun/Cooldown.is_stopped():
 		var laser := laser_scene.instantiate()
 	 	laser.position = $LaserGun.global_position
		get_parent().add_child(laser)
		$LaserGun/Cooldown.start()

func take_damage(amount: int) -> void:
	if not shield_active:
		health -= amount
		if health <= 0:
			queue_free()  # Ship crashes (reset by Level Manager)
