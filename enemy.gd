extends CharacterBody2D

@export var speed: float = 50
@export var health: float = 100
@export var lose_target_time: float = 5000
var target: CollisionObject2D = null
var detected: bool = false
var last_time_detected: float = 0
var target_velocity: Vector2 = Vector2.ZERO

func _physics_process(delta):
	target_velocity = Vector2.ZERO
	detected = false
	for body in $DetectRadius.get_overlapping_bodies():
		if body.get_collision_layer() == 1:
			target = body
			last_time_detected = Time.get_ticks_msec()
			detected = true
	if detected == false and Time.get_ticks_msec() - last_time_detected > lose_target_time:
		target = null
	if target:
		target_velocity = position.direction_to(target.position) * speed
	velocity = velocity.lerp(target_velocity, 0.1)
	if velocity.length() < 2:
		velocity = Vector2.ZERO
	move_and_slide()

func take_damage(amount):
	health -= amount
	if health < 0:
		queue_free()
