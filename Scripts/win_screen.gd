extends CanvasLayer

func _on_menu_button_pressed() -> void:
	GameManager.load_scene(0)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
