extends Node

@onready var bgm_manager = $"/root/BgmManager"

signal load_progress_updated(progress: float)
signal load_finished()

var loaded_scene: PackedScene = null
var load_state := ResourceLoader.THREAD_LOAD_INVALID_RESOURCE
var progress := []

const MAIN_SCENE_PATH = "res://scenes/main/main.tscn"

func start_load_main() -> void:
	var err = ResourceLoader.load_threaded_request(MAIN_SCENE_PATH, "PackedScene")
	if err != OK:
		print("Failed to start threaded load: %s" % err)
		return
	loaded_scene = null
	load_state = ResourceLoader.THREAD_LOAD_IN_PROGRESS
	
func _process(_delta: float) -> void:
	if load_state == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		load_state = ResourceLoader.load_threaded_get_status(MAIN_SCENE_PATH, progress)
		if progress.size() > 0:
			print("Loading progress: ", progress[0] * 100, "%")
		match load_state:
			ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				if progress.size() > 0:
					load_progress_updated.emit(progress[0])
			ResourceLoader.THREAD_LOAD_LOADED:
				loaded_scene = ResourceLoader.load_threaded_get(MAIN_SCENE_PATH)
				load_finished.emit()
			ResourceLoader.THREAD_LOAD_FAILED, ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
				print("场景加载失败或资源无效!")
		
func enter_main():
	if loaded_scene:
		get_tree().change_scene_to_packed(loaded_scene)
		bgm_manager.switch_to_game_music()
	else:
		print("错误：场景尚未加载完成或加载失败。")
