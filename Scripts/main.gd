extends Node

func _ready() -> void:
	GameManager.call_deferred("load_scene", 0)
