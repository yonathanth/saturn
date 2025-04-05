extends Area2D

var fall_speed = randf_range(100, 200)
var drift_speed = randf_range(-50, 50)
var glow_timer = 0.0  # To animate glow over time

func _ready():
	# Optional: Adjust scale
	var scale_factor = 0.045
	$Sprite2D.scale = Vector2(scale_factor, scale_factor)
	$CollisionShape2D.scale = Vector2(scale_factor, scale_factor)

func _physics_process(delta):
	# Move the ice
	position.y += fall_speed * delta
	position.x += drift_speed * delta
	if position.y > 1000:
		queue_free()
	
	# Animate glow with modulate
	glow_timer += delta
	var glow_value = (sin(glow_timer * 2) + 1) / 2  # Oscillates between 0 and 1
	$Sprite2D.modulate = Color(1, 1, 1, 0.5 + glow_value * 0.5)  # Fades alpha between 0.5 and 1

func collect():
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		collect()
