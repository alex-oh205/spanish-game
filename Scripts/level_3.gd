extends Level

@export var enemy: PackedScene
var last_time_spawned = 0
var spawn_delay = 500

func enemy_loop():
	spawn_delay = 500 - ui.anger * 30
	if last_time_spawned == 0 or Time.get_ticks_msec() - last_time_spawned > spawn_delay:
		last_time_spawned = Time.get_ticks_msec()
		spawn_enemy()

func spawn_enemy():
	var e = enemy.instantiate()
	var angle = randf_range(0, 2 * PI)
	var distance = sqrt(get_viewport().size.x ** 2 + get_viewport().size.y ** 2) / 2
	e.position = Vector2(get_viewport().size.x / 2 + distance * cos(angle),
						 get_viewport().size.y / 2 + distance * sin(angle))
	add_child(e)
	damagers.append(e)
