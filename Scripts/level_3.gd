extends Level

@export var boss: PackedScene
@export var bullet: PackedScene
@export var bullet_timer: Timer
@export var minion_timer: Timer
@export var laser: PackedScene
@export var damage_area: PackedScene
@export var hand: PackedScene
var bullet_delay = 3
var minion_delay: float
var laser_duration = 4
var current_boss = null
var current_laser = null

func enemy_begin():
	var b = boss.instantiate()
	b.position = Vector2(viewport_x / 2, viewport_y / 2)
	add_child(b)
	damagers.append(b)
	current_boss = b
	if ui.enemy_health < 4:
		current_boss.sprite.play("stage_3")
		current_boss.animation = "stage_3"
		if ui.enemy_image.animation != "stage_3":
			ui.enemy_image.play("stage_3")
	elif ui.enemy_health < 8:
		current_boss.sprite.play("stage_2")
		current_boss.animation = "stage_2"
		if ui.enemy_image.animation != "stage_2":
			ui.enemy_image.play("stage_2")
	bullet_timer.start(1)

func enemy_loop():
	if ui.enemy_health < 8:
		bullet_delay = 5 - ui.anger * 0.2
		if bullet_timer.is_stopped():
			if randi_range(0, 2) > 0:
				var h = hand.instantiate()
				h.position = [
					Vector2(viewport_x / 2, 100),
					Vector2(viewport_x / 2, viewport_y - 100),
					Vector2(100, viewport_y / 2),
					Vector2(viewport_x - 100, viewport_y / 2),
				].pick_random()
				if ui.enemy_health < 4:
					h.position = [
						Vector2(viewport_x / 2, 100),
						Vector2(viewport_x / 2, viewport_y - 100),
						Vector2(100, viewport_y / 2),
						Vector2(viewport_x - 100, viewport_y / 2),
						Vector2(100, 100),
						Vector2(viewport_x - 100, 100),
						Vector2(100, viewport_y - 100),
						Vector2(viewport_x - 100, viewport_y - 100)
					].pick_random()
				add_child(h)
			else:
				spawn_bullets(randi_range(4, 6))
			bullet_timer.start(bullet_delay)
		
		minion_delay = randf_range(7, 8) - ui.anger * 0.2
		if minion_timer.is_stopped():
			if ui.enemy_health < 4 and randi_range(0, 1) == 0:
					var shape := RectangleShape2D.new()
					shape.size = Vector2(viewport_x / 2, viewport_y)
					var x = randi_range(0, 1) * viewport_x
					var y = viewport_y / 2
					var dir = randi_range(0, 1)
					if dir == 1:
						shape.size = Vector2(viewport_x, viewport_y / 2)
						x = viewport_x / 2
						y = randi_range(0, 1) * viewport_y
					spawn_area(shape, Vector2(x, y), 1.5, 2, true)
			else:
				spawn_laser_straight()
			minion_timer.start(minion_delay)
		if current_laser != null:
			if minion_timer.time_left < minion_timer.wait_time - laser_duration:
				current_laser.fade()
				current_laser = null
	elif ui.enemy_health < 10:
		bullet_delay = 3 - ui.anger * 0.3
		if bullet_timer.is_stopped():
			if randi_range(0, 2) == 0:
				var h = hand.instantiate()
				h.position = [
					Vector2(viewport_x / 2, 100),
					Vector2(viewport_x / 2, viewport_y - 100),
					Vector2(100, viewport_y / 2),
					Vector2(viewport_x - 100, viewport_y / 2),
				].pick_random()
				add_child(h)
			else:
				spawn_bullets(3 + ui.anger)
			bullet_timer.start(bullet_delay)
	else:
		bullet_delay = 3 - ui.anger * 0.3
		if bullet_timer.is_stopped():
			if randi_range(0, 3) == 0:
				var h = hand.instantiate()
				h.position = [
					Vector2(viewport_x / 2, 100),
					Vector2(viewport_x / 2, viewport_y - 100),
					Vector2(100, viewport_y / 2),
					Vector2(viewport_x - 100, viewport_y / 2),
				].pick_random()
				add_child(h)
			else:
				spawn_bullets(3 + ui.anger * 0.5)
			bullet_timer.start(bullet_delay)
			current_boss.sprite.play("attack")

func spawn_bullets(amount: int):
	var offset = randf_range(0, 2 * PI)
	for i in range(amount):
		var b = bullet.instantiate()
		b.rotation = 2 * PI / amount * i + offset
		b.position = Vector2(viewport_x / 2, viewport_y / 2)
		add_child(b)
		damagers.append(b)

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

func spawn_area(shape: Shape2D, pos: Vector2, duration: float = 0.5, warn_duration: float = 2, no_shrink: bool = false):
	var area = damage_area.instantiate()
	area.position = pos
	area.set_collision_shape(shape)
	area.warn_time = warn_duration
	area.duration = duration
	area.no_shrink = no_shrink
	add_child(area)
	damagers.append(area)
