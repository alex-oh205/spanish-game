class_name Player extends CharacterBody2D

@export var speed: float = 300 # speed in pixels/sec
@export var hurtbox: Area2D
var last_time_shot: float = 0 # in milliseconds
var flash_interval = 50
var last_time_flashed = 0

func _ready() -> void:
	reset(Vector2(get_viewport().size.x / 2, get_viewport().size.y / 2))

func _process(delta: float) -> void:
	if hurtbox.is_invulnerable:
		if Time.get_ticks_msec() - last_time_flashed > flash_interval:
				visible = not visible
				last_time_flashed = Time.get_ticks_msec()
	else:
		visible = true

# Movement is top-down
func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()

func reset(pos: Vector2):
	position = pos
	$Hurtbox/CollisionShape2D.set_deferred("disabled", false)
	hurtbox.reset_invulnerability()

func disable():
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
	hurtbox.reset_invulnerability()

func get_input() -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
