extends CharacterBody2D

@export var speed: float = 700
@export var damager: Area2D
@export var death_timer: Timer
@export var death_time: float = 5

func _ready() -> void:
	death_timer.start(death_time)
	velocity = transform.x * speed
	GameManager.switch_turn.connect(queue_free)

func _physics_process(delta: float) -> void:
	var hit: KinematicCollision2D = move_and_collide(velocity * delta)
	if hit:
		var body = hit.get_collider()
		if body is Damageable:
			damager.check_collisions()
			queue_free()

func _on_death_timer_timeout() -> void:
	queue_free()
