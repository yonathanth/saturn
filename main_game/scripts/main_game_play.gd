extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var health_bar: Control = $HealthBar
@onready var game_over: Control = $GameOver
@onready var game_start: Control = $GameStart

func _init() -> void:
	print("MainGamePlay _init called")

func _enter_tree() -> void:
	print("MainGamePlay _enter_tree called")

func _ready() -> void:
	get_tree().paused = true
	game_start.visible = true
	game_start.start_game.connect(_on_start_game)

	var health_manager: HealthManager = player.get_node("HealthManager")
	if health_manager:
		health_manager.health_changed.connect(health_bar.update_health)
		health_manager.died.connect(_on_player_died)
		health_bar.update_health(health_manager.current_health, health_manager.max_health)
	else:
		print("Error: HealthManager not found in Player")

func _on_start_game() -> void:
	print("Starting game")
	game_start.visible = false
	get_tree().paused = false

func _on_player_died() -> void:
	print("Player died. Showing game over screen.")
	game_over.show_game_over()
