extends CharacterBody2D

@export var speed: float = 100
@export var health: float = 100
@export var damager: Area2D
@export var detect_radius: Area2D
@export var death_timer: Timer
var target: CollisionObject2D = null
var detected: bool = false
var target_velocity: Vector2 = Vector2.ZERO

func _ready():
	death_timer.start(10)

func _physics_process(delta):
	target_velocity = Vector2.ZERO
	detected = false
	for body in detect_radius.get_overlapping_areas():
		if body is Damageable:
			target = body
			detected = true
			break
	if target:
		target_velocity = position.direction_to(target.global_position) * speed
	velocity = velocity.lerp(target_velocity, 0.1)
	if velocity.length() < 2:
		velocity = Vector2.ZERO
	move_and_slide()

#func take_damage(amount):
	#health -= amount
	#if health < 0:
		#queue_free()

func _on_death_timer_timeout() -> void:
	queue_free()
