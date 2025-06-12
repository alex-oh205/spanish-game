extends Level

@export var damage_area: PackedScene
@export var megaphone: PackedScene
@export var small_area_timer: Timer
@export var big_area_timer: Timer
@export var megaphone_timer: Timer
var small_area_delay = 0.5
var big_area_delay = 6
var bullet_delay = 2
var current_megaphone = null

func enemy_begin():
	big_area_timer.start(randf_range(3, 7) - ui.anger * 0.3)
	if ui.enemy_health < 8:
		var m = megaphone.instantiate()
		add_child(m)
		current_megaphone = m
		damagers.append(m)

func enemy_loop():
	small_area_delay = 0.5 - ui.anger * 0.03
	if small_area_timer.is_stopped():
		if ui.enemy_health > 4:
			var shape := CircleShape2D.new()
			shape.radius = randf_range(100, 150) + ui.anger * 10
			spawn_area(shape, Vector2(randf_range(0, viewport_x), randf_range(0, viewport_y)))
		if ui.enemy_health < 5:
			var shape := RectangleShape2D.new()
			shape.size = Vector2(viewport_x, randf_range(10, 30))
			spawn_area(shape, Vector2(viewport_x, randf_range(0, viewport_y)))
		small_area_timer.start(small_area_delay)
	if ui.enemy_health < 3:
		if big_area_timer.is_stopped():
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
			big_area_timer.start(big_area_delay)

func spawn_area(shape: Shape2D, pos: Vector2, duration: float = 0.5, warn_duration: float = 2, no_shrink: bool = false):
	var area = damage_area.instantiate()
	area.position = pos
	area.set_collision_shape(shape)
	area.warn_time = warn_duration
	area.duration = duration
	area.no_shrink = no_shrink
	add_child(area)
	damagers.append(area)
