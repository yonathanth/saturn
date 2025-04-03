extends Area2D

@export var speed := 600.0
# Add to top


func _physics_process(delta: float) -> void:
	print("alehhooogn")
	position.y -= speed * delta
	if position.y < -50:
		queue_free()  # Despawn off-screen

	

func _on_area_entered(area: Node2D) -> void:
	if area.is_in_group("debris"):
		area.queue_free()  # Destroy rock
		queue_free()  # Destroy laser
