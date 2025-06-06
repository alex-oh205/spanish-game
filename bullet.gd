extends CharacterBody2D

@export var speed: float = 2500
@export var damage: float = 40

func _physics_process(delta: float) -> void:
	var hit: KinematicCollision2D = move_and_collide(transform.x * speed * delta)
	if hit:
		var body = hit.get_collider()
		if body.is_in_group("enemies"):
			body.take_damage(damage)
			queue_free()
