extends Control

func _ready() -> void:
	$GameOverLabel.position = Vector2(576, 200)
	$RestartButton.position = Vector2(476, 400)
	$QuitButton.position = Vector2(476, 500)
	$RestartButton.pressed.connect(_on_restart_pressed)
	$QuitButton.pressed.connect(_on_quit_pressed)
	visible = false
	print("Game over UI initialized")

func show_game_over() -> void:
	visible = true
	get_tree().paused = true
	print("Game over UI shown")

func _on_restart_pressed() -> void:
	print("Restart button pressed")
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	print("Quit button pressed")
	get_tree().quit()
