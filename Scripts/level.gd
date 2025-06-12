class_name Level extends Node2D

@export var ui: Control
@export var player: CharacterBody2D
@export var overlay: ColorRect
@export var enemy_turn_duration = 15000
@export var level_id: int
var turn = Turn.PLAYER
var enemy_turn_start_time = 0
var damagers: Array = []
@onready var viewport_x = get_viewport().size.x
@onready var viewport_y = get_viewport().size.y

enum Turn {
	PLAYER,
	ENEMY
}

func _ready() -> void:
	GameManager.switch_turn.connect(switch_turn)
	GameManager.lose_level.connect(switch_turn.bind(true))
	GameManager.win_level.connect(fade_out.bind(GameManager.advance_scene))
	ui.level_id = level_id
	ui.load_enemy()
	fade_in()

func fade_in():
	overlay.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(overlay, "color", Color(0, 0, 0, 0), 1)

func fade_out(function: Callable):
	var tween = get_tree().create_tween()
	tween.tween_property(overlay, "color", Color(0, 0, 0, 1), 1)
	tween.connect("finished", function)

func _process(delta: float) -> void:
	if turn == Turn.ENEMY:
		enemy_loop()
		if Time.get_ticks_msec() - enemy_turn_start_time > enemy_turn_duration:
			switch_turn()

func enemy_begin():
	pass

func enemy_loop():
	pass

func reset_level():
	for damager in damagers:
		if damager != null:
			damager.queue_free()
	damagers = []

func switch_turn(lose=false):
	ui.toggle_menu(lose)
	if turn == Turn.PLAYER:
		turn = Turn.ENEMY
		if level_id == 2:
			player.reset(Vector2(viewport_x / 2, viewport_y / 2 + 200))
		else:
			player.reset(Vector2(viewport_x / 2, viewport_y / 2))
		enemy_turn_start_time = Time.get_ticks_msec()
		enemy_begin()
	else:
		turn = Turn.PLAYER
		player.disable()
		reset_level()
		if not lose:
			ui.increase_anger(1)
			ui.show_actions()
	if lose:
		await get_tree().create_timer(2).timeout
		fade_out(GameManager.restart_level)
