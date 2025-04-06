extends Sprite2D

@export var scroll_speed := 50.0
var viewport_size : Vector2

func _ready():
	viewport_size = get_viewport_rect().size
	# Set initial region to cover viewport
	region_rect = Rect2(0, 0, viewport_size.x, viewport_size.y)

func _process(delta):
	region_rect.position.x += scroll_speed * delta
	# Loop when reaching image edge
	if region_rect.position.x >= texture.get_width():
		region_rect.position.x = 0
