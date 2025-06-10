extends Level

@export var enemy: PackedScene
@export var laser: PackedScene
@export var spawn_timer: Timer
@export var laser_timer: Timer
var spawn_delay = 0.5
var laser_delay = 10
var current_laser: Area2D = null
var laser_duration = 4

func enemy_begin():
	laser_timer.start(randf_range(3, 7) - ui.anger * 0.3)

func enemy_loop():
	spawn_delay = 0.5 - ui.anger * 0.04
	laser_delay = randf_range(7, 10) - ui.anger * 0.2
	if spawn_timer.is_stopped():
		spawn_enemy()
		spawn_timer.start(spawn_delay)
	if ui.anger >= 4:
		if laser_timer.is_stopped():
			spawn_laser()
			laser_timer.start(laser_delay)
		elif laser_timer.time_left < laser_timer.wait_time - laser_duration:
			if current_laser != null:
				current_laser.queue_free()
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

func spawn_laser():
	var l = laser.instantiate()
	var dir = randi_range(0, 1)
	var tween = create_tween()
	var viewport_x = get_viewport().size.x
	var viewport_y = get_viewport().size.y
	if dir == 0:
		l.position = Vector2(randi_range(0, 1) * viewport_x, 0)
		if l.position.x > viewport_x / 2:
			tween.tween_property(l, "position:x", 200, laser_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		else:
			tween.tween_property(l, "position:x", viewport_x - 200, laser_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	else:
		var flip = randi_range(0, 1)
		l.position = Vector2((1 - flip) * viewport_x, randi_range(0, 1) * viewport_y)
		l.rotation = PI / 2 + flip * PI
		if l.position.y > viewport_y / 2:
			tween.tween_property(l, "position:y", 200, laser_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		else:
			tween.tween_property(l, "position:y", viewport_y - 200, laser_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	add_child(l)
	damagers.append(l)
	current_laser = l
