extends Control

@export var dialog: Label
@export var actions: HBoxContainer
@export var answers: HBoxContainer
@export var enemy_health_bar: ProgressBar
@export var anger_meter: ProgressBar
@export var player_health_bar: ProgressBar
@export var enemy_image: TextureRect

var enemy_dialog: Array = [
	"You lost your streak yesterday. You know what happens now.",
	"All of those late assignments...",
	"Sr. Guzman stares menacingly into your eyes."
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

var enemy_health = 100
var anger = 1
var max_anger = 10

func _ready() -> void:
	enemy_image.texture = load(GameManager.enemy_images[GameManager.current_scene - 1])
	dialog.text = enemy_dialog[GameManager.current_scene - 1]
	show_actions()
	enemy_health_bar.max_value = enemy_health
	enemy_health_bar.value = enemy_health
	anger_meter.max_value = max_anger
	anger_meter.value = 1
	GameManager.player_health_changed.connect(on_player_health_changed)

func toggle_menu():
	$ActionsUI.visible = not $ActionsUI.visible

func increase_anger(amount: int):
	anger += amount
	anger = clamp(anger, 1, max_anger)
	anger_meter.value = anger

func damage_enemy(damage):
	enemy_health -= damage
	enemy_health = clamp(enemy_health, 0, 100)
	if enemy_health == 0:
		enemy_health_bar.value = enemy_health
		await get_tree().create_timer(1).timeout
		win_level()
	enemy_health_bar.value = enemy_health

func heal_player(amount):
	GameManager.heal.emit(amount)

func on_player_health_changed(health, max_health):
	player_health_bar.max_value = max_health
	player_health_bar.value = health

func show_actions():
	actions.visible = true
	answers.visible = false

func show_correct():
	pass

func turn_end():
	show_correct()
	await get_tree().create_timer(1).timeout
	GameManager.switch_turn.emit()

func _on_attack_pressed() -> void:
	if await ask_question():
		damage_enemy(20)
	else:
		increase_anger(2)
	turn_end()

func _on_negotiate_pressed() -> void:
	if await ask_question():
		increase_anger(-2)
	else:
		increase_anger(2)
	turn_end()

func _on_heal_pressed() -> void:
	if await ask_question():
		heal_player(20)
	else:
		increase_anger(2)
	turn_end()

func ask_question() -> bool:
	var current_question = questions[randi_range(0, questions.size() - 1)]
	dialog.text = current_question["question"]
	actions.visible = false
	answers.visible = true
	var shift = randi_range(0, 3)
	for button: Button in answers.get_children():
		button.text = current_question["choices"][(button.id - shift) % 4]
	var button_id = await GameManager.answered
	return button_id == (current_question["answer"] + shift) % 4

func win_level():
	GameManager.advance_scene()
