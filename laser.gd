extends Damager

func _ready() -> void:
	$TileMap.modulate = Color(1, 1, 1, 0)
	$CollisionShape2D.disabled = true
	$CollisionShape2D2.disabled = true
	var tween = get_tree().create_tween()
	tween.tween_property($TileMap, "modulate", Color(1, 1, 1, 0.2), 1).set_trans(tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.connect("finished", shoot)

func shoot():
	$TileMap.modulate = Color(1, 1, 1, 1)
	$CollisionShape2D.disabled = false
	$CollisionShape2D2.disabled = false

func fade():
	$CollisionShape2D.disabled = true
	$CollisionShape2D2.disabled = true
	$CollisionShape2D3.disabled = true
	var tween = get_tree().create_tween()
	tween.tween_property($Bird, "modulate", Color(1, 1, 1, 0), 1).set_trans(tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property($TileMap, "modulate", Color(1, 1, 1, 0), 1).set_trans(tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.connect("finished", queue_free)
