extends Node3D

@onready var bgm_manager = $"/root/BgmManager"

func load_scene(level_scene: PackedScene):
	var level_instance = level_scene.instantiate()
	add_child(level_instance)
	bgm_manager.switch_to_game_music()
