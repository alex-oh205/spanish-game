extends Level

@export var damage_area: PackedScene
var last_time_spawned = 0
var spawn_delay = 500

func enemy_loop():
	spawn_delay = 500 - ui.anger * 30
	if last_time_spawned == 0 or Time.get_ticks_msec() - last_time_spawned > spawn_delay:
		last_time_spawned = Time.get_ticks_msec()
		spawn_area()

func spawn_area():
	var area = damage_area.instantiate()
	area.position = Vector2(randf_range(0, get_viewport().size.x),
							randf_range(0, get_viewport().size.y))
	var shape = CircleShape2D.new()
	shape.radius = randf_range(50, 100)
	area.set_collision_shape(shape)
	add_child(area)
	damagers.append(area)
