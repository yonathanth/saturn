extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var health_bar: Control = $HealthBar

func _ready() -> void:
	var health_manager: HealthManager = player.get_node("HealthManager")
	health_manager.health_changed.connect(health_bar.update_health)
	health_manager.invulnerability_changed.connect(health_bar.update_invulnerability)
	health_bar.update_health(health_manager.current_health, health_manager.max_health)
