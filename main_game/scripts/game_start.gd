extends Control

signal start_game

func _ready() -> void:
	$TitleLabel.position = Vector2(576, 200)
	$PlayButton.position = Vector2(576, 400)
	$QuitButton.position = Vector2(576, 500)
	$PlayButton.pressed.connect(_on_play_pressed)
	$QuitButton.pressed.connect(_on_quit_pressed)
	print("Game start UI initialized")
	print("start button is connected ?", $PlayButton.pressed.is_connected(_on_play_pressed))

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var local_pos = $PlayButton.get_local_mouse_position()
		var button_rect = $PlayButton.get_rect()
		print("Mouse clicked at global: ", event.position, " local to PlayButton: ", local_pos)
		print("PlayButton rect: ", button_rect)
		if button_rect.has_point(local_pos):
			print("Click is within PlayButton bounds")

func _on_play_pressed() -> void:
	print("Play button pressed")
	emit_signal("start_game")

func _on_quit_pressed() -> void:
	print("Quit button pressed")
	get_tree().quit()
