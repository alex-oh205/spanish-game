extends Damager

@export var collision_shape: CollisionShape2D
@export var polygon: Polygon2D
@export var warn_timer: Timer
@export var warn_time: float = 2
@export var death_timer: Timer
@export var duration: float = 0.5

var warning_color = Color(1, 1, 0, 0.2)  # Initial faint color for the warning state
var active_color = Color(1, 1, 0, 1)  # Red color for active damage state
var no_shrink: bool = false

func _ready() -> void:
	polygon.modulate = Color(1, 1, 0, 0)
	collision_shape.disabled = true
	add_tween("modulate", warning_color, warn_time, Tween.TRANS_SINE, Tween.EASE_OUT)
	warn_timer.start(warn_time)

func add_tween(property: String, value, duration: float, transition: Tween.TransitionType = Tween.TRANS_LINEAR, ease: Tween.EaseType = Tween.EASE_IN_OUT):
	var tween := get_tree().create_tween()
	tween.tween_property(polygon, property, value, duration).set_trans(transition).set_ease(ease)

func set_collision_shape(shape: Shape2D):
	collision_shape.shape = shape
	update_polygon_shape()

func update_polygon_shape():
	var shape = collision_shape.shape
	# If it's a polygon shape, set the Polygon2D points
	if shape is ConvexPolygonShape2D:
		var points = collision_shape.shape.points
		polygon.polygon = points
	# If it's a rectangle shape, create the four points for the Polygon2D
	elif shape is RectangleShape2D:
		var rect = collision_shape.shape.size * 2
		polygon.polygon = [
			Vector2(-rect.x / 2, -rect.y / 2),
			Vector2(rect.x / 2, -rect.y / 2),
			Vector2(rect.x / 2, rect.y / 2),
			Vector2(-rect.x / 2, rect.y / 2)
		]
	# If it's a circle, create a polygon to approximate it (using many points)
	elif shape is CircleShape2D:
		var radius = collision_shape.shape.radius
		var num_points = 32
		var points = []
		for i in range(num_points):
			var angle = i * 2 * PI / num_points
			points.append(Vector2(cos(angle) * radius, sin(angle) * radius))
		polygon.polygon = points
	# Align the Polygon2D position with the CollisionShape2D
	polygon.position = collision_shape.position

func _on_warn_timer_timeout() -> void:
	# After the warning time, make the area active
	polygon.modulate = active_color  # Set active color (red)
	
	# Enable collision detection for damage
	collision_shape.disabled = false
	
	if not no_shrink:
		add_tween("scale", Vector2(0, 0), duration, Tween.TRANS_BACK, Tween.EASE_IN)
	death_timer.start(duration)

func _on_death_timer_timeout() -> void:
	queue_free()
