extends Node3D

signal load_progress_updated(progress: float)
signal load_finished()

@onready var game_manager = $"/root/GameManager"
@onready var level_container = $LevelContainer
@onready var level_loading = $CanvasLayer/LevelLoading
@onready var pause = $CanvasLayer/Pause

var loaded_scene: PackedScene = null
var load_state := ResourceLoader.THREAD_LOAD_INVALID_RESOURCE
var progress := []
var current_level: int

const LEVEL_SCENE_PATH = "res://scenes/levels/level%02d.tscn"

func _notification(what):
	# NOTIFICATION_WM_GO_BACK_REQUEST 是 Android 平台发出的返回请求通知。
	# 它的优先级极高，绕过正常的输入事件管道（_input, _unhandled_input）。
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		# 1. 打印日志确认捕获
		pause.do_pause_menu();
		#push_warning(">>> 终极捕获成功：NOTIFICATION_WM_GO_BACK_REQUEST! <<<")
		# 2. 执行你的自定义逻辑（例如，打开/关闭菜单）
		#_handle_pause_menu()

		# 注意：这里不需要调用 get_viewport().set_input_as_handled()，
		# 因为它是一个通知而不是输入事件。

func _ready():
	load_finished.connect(_on_load_finished)
	load_finished.connect(level_loading._on_load_finished)
	load_progress_updated.connect(level_loading._on_load_progress_updated)
	start_load_level(game_manager.level)
	
func _process(_delta: float) -> void:
	if load_state == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		var level_scene_path := LEVEL_SCENE_PATH % current_level
		load_state = ResourceLoader.load_threaded_get_status(level_scene_path, progress)
		match load_state:
			ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				if progress.size() > 0:
					load_progress_updated.emit(progress[0])
			ResourceLoader.THREAD_LOAD_LOADED:
				loaded_scene = ResourceLoader.load_threaded_get(level_scene_path)
				load_finished.emit()
			ResourceLoader.THREAD_LOAD_FAILED, ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
				print("场景加载失败或资源无效!")

func start_load_level(level: int) -> void:
	current_level = level
	var err = ResourceLoader.load_threaded_request(LEVEL_SCENE_PATH % current_level, "PackedScene")
	if err != OK:
		print("Failed to start threaded load: %s" % err)
		return
	loaded_scene = null
	load_state = ResourceLoader.THREAD_LOAD_IN_PROGRESS
	level_loading.visible = true
	
func _on_load_finished() -> void:
	load_state = ResourceLoader.THREAD_LOAD_INVALID_RESOURCE
	if loaded_scene:
		level_container.load_scene(loaded_scene)
	else:
		print("错误：场景尚未加载完成或加载失败。")
