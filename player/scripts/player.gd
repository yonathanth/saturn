extends CharacterBody2D

@export var scroll_speed: float = 50.0
var viewport_size: Vector2

func _ready() -> void:
	viewport_size = get_viewport_rect().size
	region_rect = Rect2(0, 0, viewport_size.x, viewport_size.y)

func _process(delta: float) -> void:
	region_rect.position.x += scroll_speed * delta
	if region_rect.position.x >= texture.get_width():
		region_rect.position.x = 0
