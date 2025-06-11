extends CanvasLayer

@export var overlay: ColorRect

func _ready() -> void:
	overlay.visible = true
	overlay.color = Color(0, 0, 0, 1)
	var tween = get_tree().create_tween()
	tween.tween_property(overlay, "color", Color(0, 0, 0, 0), 1)

func _on_menu_button_pressed() -> void:
	GameManager.load_scene(0)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
