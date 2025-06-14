extends Level

@export var enemy: PackedScene
@export var laser: PackedScene
@export var spawn_timer: Timer
@export var laser_timer: Timer
var spawn_delay = 0.7
var laser_delay = 10
var current_laser: Area2D = null
var laser_duration = 4

func enemy_begin():
	laser_timer.start(randf_range(3, 4))

func enemy_loop():
	spawn_delay = 0.7 - ui.anger * 0.04
	laser_delay = randf_range(7, 10) - ui.anger * 0.2
	if spawn_timer.is_stopped():
		spawn_enemy()
		spawn_timer.start(spawn_delay)
	if laser_timer.is_stopped():
		if ui.enemy_health < 7:
			if ui.enemy_health < 5 and randi_range(0, 1) == 0:
				laser_delay = 8
				spawn_laser_rotate()
			elif ui.enemy_health < 3 and randi_range(0, 1) == 0:
				spawn_laser_rotate_corner()
			else:
				spawn_laser_straight()
			laser_timer.start(laser_delay)
	elif laser_timer.time_left < laser_timer.wait_time - laser_duration:
		if current_laser != null:
			current_laser.fade()
			current_laser = null

func spawn_enemy():
	var e = enemy.instantiate()
	var angle = randf_range(0, 2 * PI)
	var distance = sqrt(get_viewport().size.x ** 2 + get_viewport().size.y ** 2) / 2
	e.position = Vector2(get_viewport().size.x / 2 + distance * cos(angle),
						 get_viewport().size.y / 2 + distance * sin(angle))
	e.speed = randf_range(150, 200) + ui.anger * 20
	e.direction = e.position.direction_to(player.position)
	add_child(e)
	damagers.append(e)

func spawn_laser_straight():
	var l = laser.instantiate()
	var dir = randi_range(0, 1)
	var tween = get_tree().create_tween()
	if dir == 0:
		l.position = Vector2(randi_range(0, 1) * viewport_x, 60)
		if l.position.x > viewport_x / 2:
			tween.tween_property(l, "position:x", 200, laser_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		else:
			tween.tween_property(l, "position:x", viewport_x - 200, laser_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	else:
		var flip = randi_range(0, 1)
		l.position = Vector2((1 - flip) * (viewport_x - 120) + 60, randi_range(0, 1) * viewport_y)
		l.rotation = PI / 2 + flip * PI
		if l.position.y > viewport_y / 2:
			tween.tween_property(l, "position:y", 200, laser_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		else:
			tween.tween_property(l, "position:y", viewport_y - 200, laser_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	add_child(l)
	damagers.append(l)
	current_laser = l

func spawn_laser_rotate():
	var l = laser.instantiate()
	var dir = [-1, 1].pick_random()
	l.position = Vector2(viewport_x / 2, viewport_y / 2)
	l.rotation = randf_range(0, 2 * PI)
	var tween = get_tree().create_tween()
	tween.tween_property(l, "rotation", l.rotation + dir * 2 * PI, 6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	add_child(l)
	damagers.append(l)
	current_laser = l

func spawn_laser_rotate_corner():
	var l = laser.instantiate()
	var loc = Vector2(randi_range(0, 1), randi_range(0, 1))
	l.position = Vector2(loc.x * (viewport_x - 120) + 60, loc.y * (viewport_y - 120) + 60)
	var dir = [-1, 1].pick_random()
	match loc:
		Vector2(0, 0):
			l.rotation = (-dir - 1) * PI / 4
		Vector2(0, 1):
			l.rotation = (-dir - 3) * PI / 4
		Vector2(1, 0):
			l.rotation = (-dir + 1) * PI / 4
		Vector2(1, 1):
			l.rotation = (-dir + 3) * PI / 4
	var tween = get_tree().create_tween()
	tween.tween_property(l, "rotation", l.rotation + dir * (80 * PI / 180), 4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	add_child(l)
	damagers.append(l)
	current_laser = l
