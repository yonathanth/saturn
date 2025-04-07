extends Control

@onready var health_frame: Sprite2D = $HealthFrame
@onready var health_label: Label = $HealthLabel

var frame_textures: Array[Texture2D] = []
var previous_health: float = -1.0  # Track previous health to detect damage

func _ready() -> void:
	for i in range(1, 21):
		var texture_path: String = "res://health/assets/frame/frame_%d.png" % i
		var texture: Texture2D = load(texture_path)
		if texture:
			frame_textures.append(texture)
		else:
			push_error("Failed to load texture: %s" % texture_path)

func update_health(current: float, maximum: float) -> void:
	health_label.text = str(int(current)) + "/" + str(int(maximum))
	
	var health_percentage: float = (current / maximum) * 100.0
	var frame_index: int = int(health_percentage / 5.0)
	frame_index = clamp(frame_index, 0, 19)
	
	if frame_textures.size() > frame_index:
		health_frame.texture = frame_textures[frame_index]
	
	# Flash the health bar red if the player took damage
	if previous_health > current and current > 0:  # Health decreased (damage taken)
		var tween = create_tween()
		tween.tween_property(health_frame, "modulate", Color.RED, 0.1)
		tween.tween_property(health_frame, "modulate", Color.WHITE, 0.1)
	
	# Update previous health for the next call
	previous_health = current
	
	# Low health warning (flash if below 25%)
	if health_percentage < 25.0:
		var tween = create_tween()
		tween.tween_property(health_frame, "modulate", Color.RED, 0.5)
		tween.tween_property(health_frame, "modulate", Color.WHITE, 0.5)
		tween.set_loops()
	else:
		# Stop any ongoing low-health flashing if health is above 25%
		health_frame.modulate = Color.WHITE
