extends "res://Scripts/bullet.gd"

func _physics_process(delta: float) -> void:
	var hit: KinematicCollision2D = move_and_collide(velocity * delta)
	if hit:
		var body = hit.get_collider()
		if body is Damageable:
			damager.check_collisions()
			queue_free()
		else:
			velocity = velocity.bounce(hit.get_normal())
			rotation = velocity.angle()

func _on_death_timer_timeout() -> void:
	fade_out(0.5)

func fade_out(duration):
	var tween = get_tree().create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate:a", 0, duration)
	tween.connect("finished", queue_free)
