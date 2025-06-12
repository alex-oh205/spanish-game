class_name Damageable extends Area2D

@export var max_health: int = 100
@export var invulnerability_duration = 1 # in seconds
@export var invulnerability_timer: Timer
var health = max_health
var is_invulnerable = false

func _ready() -> void:
	GameManager.heal.connect(heal)
	GameManager.player_health_changed.emit.call_deferred(health, max_health)

func take_damage(damage: int) -> void:
	if false:
		invulnerability_timer.start(invulnerability_duration)
		is_invulnerable = true
		health -= damage
		health = clamp(health, 0, max_health)
		GameManager.player_health_changed.emit(health, max_health)
		if health == 0:
			GameManager.lose_level.emit()

func heal(amount: int) -> void:
	health += amount
	clamp(health, 0, max_health)
	GameManager.player_health_changed.emit(health, max_health)

func reset_invulnerability():
	is_invulnerable = false
	invulnerability_timer.stop()

func _on_invulnerability_timeout() -> void:
	is_invulnerable = false
	visible = true
