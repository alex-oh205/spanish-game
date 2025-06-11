extends Control

@export var dialog: Label
@export var actions: HBoxContainer
@export var answers: HBoxContainer
@export var enemy_health_bar: ProgressBar
@export var anger_meter: ProgressBar
@export var player_health_bar: ProgressBar
@export var enemy_image: AnimatedSprite2D

var enemy_dialog: Array = [
	"Ayer perdiste tu racha. Ya sabes lo que pasa ahora.",
	"Todas esas tareas tardes...",
	"Sr. Guzmán te mira amenazadoramente a los ojos."
]

var game_over_dialog: Array = [
	"Game Over",
	"Game Over",
	"Game Over"
]

var questions: Array = [
	{
		"question": "¿Cómo se dice 'apple' en español?",
		"choices": [
			"manzana",
			"banana",
			"fresa",
			"pina",
		],
		"answer": 0
	},
	{
		"question": "¿Cuál es el verbo 'to be' permanente?",
		"choices": [
			"correct",
			"something",
			"something",
			"something",
		],
		"answer": 0
	},
	{
		"question": "¿Qué significa 'libro'?",
		"choices": [
			"correct",
			"something",
			"something",
			"something",
		],
		"answer": 0
	},
]

var enemy_health = 8
var anger = 1
var max_anger = 10
var enemy_image_height = 250
var current_question: Dictionary
var current_answer: int
var level_id: int

func _ready() -> void:
	show_actions()
	enemy_health_bar.max_value = enemy_health
	enemy_health_bar.value = enemy_health
	anger_meter.max_value = max_anger
	anger_meter.value = 1
	GameManager.player_health_changed.connect(on_player_health_changed)

func load_enemy():
	enemy_image.sprite_frames = load(GameManager.enemy_frames[level_id])
	enemy_image.play("enemy_anim")
	if level_id == 2:
		enemy_image_height = 350
		enemy_image.offset = Vector2(-20, -40)
	var height_scale = 1.0 * enemy_image_height / enemy_image.sprite_frames.get_frame_texture("enemy_anim", 0).get_height()
	enemy_image.scale = Vector2(height_scale, height_scale)
	if level_id == 1:
		enemy_image.texture_filter = TextureFilter.TEXTURE_FILTER_LINEAR
	dialog.text = enemy_dialog[level_id]

func toggle_menu(lose=false):
	$ActionsUI.visible = not $ActionsUI.visible
	if lose:
		on_lose_level()

func increase_anger(amount: int):
	anger += amount
	anger = clamp(anger, 1, max_anger)
	anger_meter.value = anger

func damage_enemy(damage) -> bool:
	enemy_health -= damage
	enemy_health = clamp(enemy_health, 0, 100)
	if enemy_health == 0:
		enemy_health_bar.value = enemy_health
		GameManager.win_level.emit()
		return true
	enemy_health_bar.value = enemy_health
	return false

func heal_player(amount):
	GameManager.heal.emit(amount)

func on_player_health_changed(health, max_health):
	player_health_bar.max_value = max_health
	player_health_bar.value = health

func on_lose_level():
	actions.visible = false
	answers.visible = false
	$HUD.visible = false
	dialog.text = game_over_dialog[GameManager.current_scene - 1]

func show_actions():
	actions.visible = true
	answers.visible = false
	dialog.text = enemy_dialog[GameManager.current_scene - 1]

func show_correct(choice: int):
	for button: Button in answers.get_children():
		button.disabled = true
		if button.id == choice:
			button.modulate = Color(255, 0, 0)
		if button.id == current_answer:
			button.modulate = Color(0, 255, 0)

func turn_end(choice: int):
	show_correct(choice)
	await get_tree().create_timer(1).timeout
	GameManager.switch_turn.emit()

func _on_attack_pressed() -> void:
	var choice = await ask_question()
	if choice == current_answer:
		if await damage_enemy(1): # Returns true if enemy is defeated
			return
	else:
		increase_anger(2)
	turn_end(choice)

func _on_negotiate_pressed() -> void:
	var choice = await ask_question()
	if choice == current_answer:
		increase_anger(-2)
	else:
		increase_anger(2)
	turn_end(choice)

func _on_heal_pressed() -> void:
	var choice = await ask_question()
	if choice == current_answer:
		heal_player(30)
	else:
		increase_anger(2)
	turn_end(choice)

func ask_question() -> int:
	current_question = questions[randi_range(0, questions.size() - 1)]
	dialog.text = current_question["question"]
	actions.visible = false
	answers.visible = true
	var shift = randi_range(0, 3)
	for button: Button in answers.get_children():
		button.text = current_question["choices"][(button.id - shift) % 4]
		button.modulate = Color(1, 1, 1, 1)
		button.disabled = false
	var button_id = await GameManager.answered
	current_answer = (current_question["answer"] + shift) % 4
	return button_id
