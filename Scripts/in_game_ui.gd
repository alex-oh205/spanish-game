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
		"question": "Me siento enfermo, yo debo ir al ______.",
		"choices": [
			"cuerpo",
			"consultorio médico",
			"pierna",
			"examen médico",
		],
		"answer": 1
	},
	{
		"question": "Se me ____ y rompió la pierna mientras patinaba.",
		"choices": [
			"cayó",
			"lastimó",
			"torció",
			"dio",
		],
		"answer": 0
	},
	{
		"question": "Tengo gripe, y necesito _________.",
		"choices": [
			"salud",
			"operacion",
			"medicamentos",
			"radiografía",
		],
		"answer": 2
	},
	{
		"question": "Él fue al ______, que sacó un diente.
",
		"choices": [
			"dentista",
			"dóctor",
			"clinica",
			"enfermera",
		],
		"answer": 0
	},
	{
		"question": "Toma tus medicamentos ______.",
		"choices": [
			"con frecuencia",
			"a menudo",
			"apenas",
			"a tiempo",
		],
		"answer": 3
	},
	{
		"question": "La parte más importante del cuerpo es ____.",
		"choices": [
			"el dedo",
			"el corazón",
			"la pierna",
			"el ojo",
		],
		"answer": 1
	},
	{
		"question": "_____ a menudo en el karaoke.",
		"choices": [
			"escuchaba música",
			"comía",
			"cantaba",
			"bebía",
		],
		"answer": 2
	},
	{
		"question": "Cuando era niño, ___ de vacaciones a España a menudo.",
		"choices": [
			"iba",
			"fui",
			"estuve",
			"estaba",
		],
		"answer": 0
	},
	{
		"question": "Se ____ ropa y gafas de sol.",
		"choices": [
			"vende",
			"compra",
			"compran",
			"venden",
		],
		"answer": 3
	},
	{
		"question": "Ella dibuja ____.",
		"choices": [
			"maravillosamente",
			"maravillosa",
			"mal",
			"graciosomente",
		],
		"answer": 0
	},
	{
		"question": "¿Puedo darte cincuenta pesos ___ las gafas de sol?",
		"choices": [
			"por",
			"para",
			"",
			"",
		],
		"answer": 0
	},
	{
		"question": "Yo hablaba contigo ___ la computadora.",
		"choices": [
			"por",
			"para",
			"",
			"",
		],
		"answer": 0
	},
	{
		"question": "Yo fui a Hawaii ___ cinco días.",
		"choices": [
			"por",
			"para",
			"",
			"",
		],
		"answer": 0
	},
	{
		"question": "___ la semana, yo vine al hospital ___ mejor salud.",
		"choices": [
			"para, por",
			"por, para",
			"por, por",
			"para, para",
		],
		"answer": 1
	},
	{
		"question": "¿Qué es el mnemotécnico de por?",
		"choices": [
			"PERFECT",
			"DREAM",
			"",
			"",
		],
		"answer": 1
	},
	{
		"question": "Tú debes ______ si tu deseas vivir en esta casa.",
		"choices": [
			"aquilar",
			"alquilar",
			"alquiler",
			"aquier",
		],
		"answer": 1
	},
	{
		"question": "_____ la mesa, por favor.",
		"choices": [
			"levanta",
			"hace",
			"salgo",
			"ponga",
		],
		"answer": 3
	},
	{
		"question": "______ ningunas electrónicas, por favor.",
		"choices": [
			"No pone",
			"No tengas",
			"No seas",
			"No vayas",
		],
		"answer": 1
	},
	{
		"question": "¿Esto es ____ yo pregunté?",
		"choices": [
			"lo que",
			"que",
			"quien",
			"quienes",
		],
		"answer": 0
	},
	{
		"question": "____ al camarero por tu comida. ",
		"choices": [
			"pídele",
			"golpea",
			"No hables",
			"habla",
		],
		"answer": 0
	},
	{
		"question": "___ dos ejercicios.",
		"choices": [
			"Haz",
			"Habla",
			"No veas",
			"Toma",
		],
		"answer": 0
	},
	{
		"question": "___ de la cama en la habitación y ___ con la mesa.",
		"choices": [
			"Sal, levanta",
			"Entre, levanta",
			"Entre, no molestes",
			"Sal, ayúdame",
		],
		"answer": 3
	},
	{
		"question": "No ____ a la escuela. Tú eres expulsado.",
		"choices": [
			"entras",
			"vuelvas",
			"atendas",
			"escribas",
		],
		"answer": 1
	},
	{
		"question": "No ___ estupido. ____ el jarrón de nuevo allí.",
		"choices": [
			"estés, come",
			"estés, pon",
			"seas, come",
			"seas, pon",
		],
		"answer": 3
	},
	{
		"question": "¿Cuál es la palabra para “computer”?",
		"choices": [
			"el canal",
			"la computación",
			"la computadora",
			"la red",
		],
		"answer": 2
	},
	{
		"question": "¿Qué es 'la radiografía' en inglés?",
		"choices": [
			"radio",
			"graph",
			"x-ray",
			"radio waves",
		],
		"answer": 2
	},
	{
		"question": "¿Qué te da direcciones?",
		"choices": [
			"la aplicación",
			"el buscador",
			"el internet",
			"el navegador GPS",
		],
		"answer": 3
	},
	{
		"question": "¿Qué debes hacerle a tu coche cada mes?",
		"choices": [
			"arreglar",
			"revisar el aceite",
			"estrellar",
			"besar",
		],
		"answer": 1
	},
	{
		"question": "Yo ______ el carro antes de conducir.",
		"choices": [
			"borré",
			"arranqué",
			"empujé",
			"conduje",
		],
		"answer": 1
	},
	{
		"question": "¿Cómo se dice la frase 'my car' en español?",
		"choices": [
			"El carro mío.",
			"El carro tuyo.",
			"El carro suyo.",
			"El carro nuestro.",
		],
		"answer": 0
	},
	{
		"question": "¿Es la silla tuya? Si, la silla es ____.",
		"choices": [
			"su",
			"mi",
			"tu",
			"mía",
		],
		"answer": 3
	},
	{
		"question": "¿Es ella una amiga ______?",
		"choices": [
			"mío",
			"nuestro",
			"tuya",
			"su",
		],
		"answer": 2
	},
	{
		"question": "de ustedes (feminine, plural)",
		"choices": [
			"suyos",
			"suyas",
			"tuyas",
			"tuyos",
		],
		"answer": 1
	},
	{
		"question": "¿Es la culpa mía? No, la culpa es ____. (theirs)",
		"choices": [
			"nuestros",
			"tuyos",
			"suya",
			"suyos",
		],
		"answer": 2
	},
	{
		"question": "¿Cuál es un pronombre recíproco reflexivo?",
		"choices": [
			"te",
			"se",
			"me",
			"nuestro",
		],
		"answer": 1
	},
	{
		"question": "Mi abuelo y mi abuela _________. Ellos son muy alegres.",
		"choices": [
			"se quieren",
			"se enojan",
			"se odian",
			"se abrazan",
		],
		"answer": 0
	},
	{
		"question": "Mi máma y papá _______ todos los días",
		"choices": [
			"se salimos",
			"se encuentra",
			"se vimos",
			"se besan",
		],
		"answer": 3
	},
	{
		"question": "Cuando mi amigo y yo _________ en la calle, ______.",
		"choices": [
			"nos vimos, nos besan",
			"nos vimos, se encontramos",
			"nos vimos, nos hablamos",
			"nos vimos, se abrazan",
		],
		"answer": 2
	},
	{
		"question": "Ellos _______ cuando ________.",
		"choices": [
			"nos abrazamos, nos encontramos",
			"se hablamos, se encontramos",
			"se saludan, se encontraron",
			"nos ayudan, nos encontraron",
		],
		"answer": 2
	}
]

var questions_left = questions.duplicate()

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
		enemy_image.offset = Vector2(-20, -30)
		enemy_health = 12
		enemy_health_bar.max_value = enemy_health
		enemy_health_bar.value = enemy_health
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
		increase_anger(1)
	turn_end(choice)

func _on_negotiate_pressed() -> void:
	var choice = await ask_question()
	if choice == current_answer:
		increase_anger(-3)
	else:
		increase_anger(1)
	turn_end(choice)

func _on_heal_pressed() -> void:
	var choice = await ask_question()
	if choice == current_answer:
		heal_player(50)
	else:
		increase_anger(1)
	turn_end(choice)

func ask_question() -> int:
	if questions_left.is_empty():
		questions_left = questions.duplicate()
	current_question = questions_left.pop_at(randi_range(0, questions_left.size() - 1))
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
