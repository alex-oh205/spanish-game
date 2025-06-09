class_name Damager extends Area2D

@export var damage: int = 10

func _physics_process(delta: float) -> void:
	check_collisions()

func check_collisions():
	for body in get_overlapping_areas():
		if body is Damageable:
			body.take_damage(damage)
