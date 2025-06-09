extends Button

@export var id: int

func _on_pressed() -> void:
	GameManager.answered.emit(id)
