extends Damager

@export var sprite: AnimatedSprite2D
var animation = "enemy_anim"

func _on_animated_sprite_2d_animation_finished() -> void:
	sprite.play(animation)
