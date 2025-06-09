class_name Level extends Node2D

@export var ui: Control
@export var player: CharacterBody2D
#@export var boss: CharacterBody2D
var turn = Turn.PLAYER
var enemy_turn_duration = 20000
var enemy_turn_start_time = 0
var damagers: Array = []

enum Turn {
	PLAYER,
	ENEMY
}

func _ready() -> void:
	GameManager.switch_turn.connect(switch_turn)

func _process(delta: float) -> void:
	if turn == Turn.ENEMY:
		enemy_loop()
		if Time.get_ticks_msec() - enemy_turn_start_time > enemy_turn_duration:
			switch_turn()

func enemy_loop():
	pass

func reset_level():
	for damager in damagers:
		if damager != null:
			damager.queue_free()
	damagers = []

func switch_turn():
	ui.toggle_menu()
	if turn == Turn.PLAYER:
		turn = Turn.ENEMY
		player.reset()
		enemy_turn_start_time = Time.get_ticks_msec()
	else:
		turn = Turn.PLAYER
		player.disable()
		reset_level()
		ui.increase_anger(1)
		ui.show_actions()
