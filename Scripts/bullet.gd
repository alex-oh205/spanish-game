extends CharacterBody2D

@export var speed: float = 700
@export var damager: Area2D
@export var death_timer: Timer
@export var death_time = 5

func _ready():
	$Sprite2D.modulate = Color(1, 0, 0, 1)

func _physics_process(delta: float) -> void:
	var hit: KinematicCollision2D = move_and_collide(transform.x * speed * delta)
	if hit:
		var body = hit.get_collider()
		if body is Damageable:
			damager.check_collisions()
			queue_free()

func _on_death_timer_timeout() -> void:
	queue_free()
