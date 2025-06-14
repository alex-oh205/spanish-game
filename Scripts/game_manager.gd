extends Node

var current_scene := 0
var scenes: Array = [
	"res://main_menu.tscn",
	"res://level_1.tscn",
	"res://level_2.tscn",
	"res://level_3.tscn",
	"res://win_screen.tscn",
]

var enemy_frames: Array = [
	"res://Assets/Art/AnimationFrames/duolingo_frames.tres",
	"res://Assets/Art/AnimationFrames/wooly_frames.tres",
	"res://Assets/Art/AnimationFrames/guzman_frames.tres",
]

signal answered
signal switch_turn
signal player_health_changed
signal heal
signal lose_level
signal win_level

func load_scene(scene_num) -> void:
	get_tree().change_scene_to_file(scenes[scene_num])
	current_scene = scene_num

func advance_scene() -> void:
	load_scene(current_scene + 1)

func restart_level():
	get_tree().reload_current_scene()
