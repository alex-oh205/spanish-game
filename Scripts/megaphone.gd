extends Damager

@export var projectile: PackedScene
@export var muzzle: Marker2D
@export var timer: Timer
@export var shoot_delay: float = 0.5
var short_delay: float = 0.03
var target_position: Vector2
var speed = 200

func _ready() -> void:
	timer.start(shoot_delay)
	position = Vector2(randf_range(0, get_viewport().size.x), 0)
	set_target()

func set_target():
	var target_position = Vector2(randf_range(0, get_viewport().size.x), 0)
	var time = position.distance_to(target_position) / speed
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", target_position, time).set_trans(Tween.TRANS_SINE)
	tween.connect("finished", set_target)

func spawn_projectile():
	for i in range(3):
		var p = projectile.instantiate()
		p.global_position = muzzle.global_position
		p.global_rotation = rotation + PI / 2
		get_tree().root.add_child(p)
		await get_tree().create_timer(short_delay).timeout

func _on_timer_timeout() -> void:
	spawn_projectile()
