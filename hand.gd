extends Node2D

@export var bullet: PackedScene
@export var death_timer: Timer
@onready var sprite = $Sprite2D
var death_time = 1.5

func _ready() -> void:
	sprite.modulate = Color(1, 1, 1, 0)
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate", Color(1, 1, 1, 1), 1)
	tween.connect("finished", spawn_bullets)
	death_timer.start(death_time)

func spawn_bullets():
	for i in range(1):
		var b = bullet.instantiate()
		var c = bullet.instantiate()
		b.rotation = randf_range(0, 2 * PI)
		b.global_position = position
		b.death_time = 10
		c.rotation = randf_range(0, 2 * PI)
		c.global_position = position
		c.death_time = 5
		get_tree().root.add_child(b)
		get_tree().root.add_child(c)
		
func _on_death_timer_timeout() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate", Color(1, 1, 1, 0), 1)
	tween.connect("finished", queue_free)
