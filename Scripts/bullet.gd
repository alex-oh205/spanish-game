extends CharacterBody2D

@export var speed: float = 2500
@export var damager: Area2D

func _physics_process(delta: float) -> void:
	var hit: KinematicCollision2D = move_and_collide(transform.x * speed * delta)
	if hit:
		var body = hit.get_collider()
		if body is Damageable:
			damager.check_collisions()
			queue_free()
