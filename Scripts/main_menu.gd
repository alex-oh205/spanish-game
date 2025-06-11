extends CanvasLayer

@export var overlay: ColorRect

func _ready() -> void:
	overlay.visible = true
	overlay.color = Color(0, 0, 0, 0)

# Start the game (go to Level 1)
func _on_start_button_pressed():
	var tween = get_tree().create_tween()
	tween.tween_property(overlay, "color", Color(0, 0, 0, 1), 1)
	tween.connect("finished", start)

func start():
	GameManager.load_scene(1)

# Quit the game
func _on_quit_button_pressed():
	get_tree().quit()
