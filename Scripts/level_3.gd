extends Level

@export var bullet: PackedScene
var last_time_spawned = 0
var spawn_delay = 0.5

func enemy_loop():
	spawn_delay = 0.5 - ui.anger * 0.03
	if last_time_spawned == 0 or Time.get_ticks_msec() - last_time_spawned > spawn_delay:
		last_time_spawned = Time.get_ticks_msec()
		spawn_bullets(20 + ui.anger * 5)
	if ui.enemy_health < 7:
		pass

func spawn_bullets(amount):
	for i in range(amount):
		var b = bullet.instantiate()
		b.rotation = 2 * PI / amount * i
		b.position = Vector2(viewport_x / 2, viewport_y)
		add_child(b)
		damagers.append(b)
