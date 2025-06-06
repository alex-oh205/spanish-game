extends CharacterBody2D

# Spanish Shooter Game (Godot GDScript)
# 3 levels, final level is bullet hell, top-down shooter with quiz mechanics

@export var speed: float = 100	# speed in pixels/sec
@export var player_health: int = 3
@export var Bullet: PackedScene
@export var shoot_delay: float = 500	# in milliseconds
var current_level: int = 1
var spanish_questions: Array = [
	{"q": "¿Cómo se dice 'apple' en español?", "a": "manzana"},
	{"q": "¿Cuál es el verbo 'to be' permanente?", "a": "ser"},
	{"q": "¿Qué significa 'libro'?", "a": "book"}
]
var last_time_shot: float = 0	# in milliseconds

func _ready() -> void:
	#load_level(current_level)
	pass

func load_level(level) -> void:
	match level:
		1:
			load_tutorial_level()
		2:
			load_vhl_level()
		3:
			load_final_boss_level()

func load_tutorial_level() -> void:
	print("Level 1: Tutorial - Boss: Duolingo Bird")
	# Spawn Duolingo characters as enemies
	spawn_enemy("res://Enemies/DuolingoEnemy.tscn")
	# Spawn Duolingo Bird as boss after defeating enemies

func load_vhl_level() -> void:
	print("Level 2: VHL Subboss Level - Boss: VHL Egg Man")
	# Spawn VHL textbooks as enemies
	spawn_enemy("res://Enemies/VHLEnemy.tscn")
	# Spawn VHL Egg Man as boss

func load_final_boss_level() -> void:
	print("Level 3: Bullet Hell - Boss: Sr. Guzman")
	# Bullet hell mechanics with mini Guzmans as enemies
	spawn_enemy("res://Enemies/MiniGuzman.tscn")
	# Final boss: Sr. Guzman with complex patterns

func spawn_enemy(scene_path) -> void:
	var enemy_scene = load(scene_path)
	var enemy_instance = enemy_scene.instance()
	add_child(enemy_instance)

func take_damage() -> void:
	var question = spanish_questions[randi() % spanish_questions.size()]
	var answer = ask_question(question["q"])
	if answer != question["a"]:
		player_health -= 1
		print("Incorrect! You lose 1 HP. Health: ", player_health)
	else:
		print("Correct! No damage taken.")

func ask_question(q) -> String:
	# Placeholder function for quiz input
	print(q)
	return "placeholder"  # Replace with user input system

func shoot() -> void:
	var bullet = Bullet.instantiate()
	owner.add_child(bullet)
	bullet.transform = $Muzzle.global_transform

func get_input() -> void:
	look_at(get_global_mouse_position())
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	if Input.is_action_pressed("shoot"):
		if Time.get_ticks_msec() - last_time_shot > shoot_delay:
			shoot()
			last_time_shot = Time.get_ticks_msec()

# Movement is top-down
func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()

# Call this on defeating each boss
func advance_level() -> void:
	current_level += 1
	if current_level <= 3:
		load_level(current_level)
	else:
		print("You win the game!")
