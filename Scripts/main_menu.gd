extends CanvasLayer

# Start the game (go to Level 1)
func _on_start_button_pressed():
	GameManager.load_scene(1)

# Quit the game
func _on_quit_button_pressed():
	get_tree().quit()
