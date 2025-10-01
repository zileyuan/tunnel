extends Node

signal score_changed(new_score)
signal level_changed(new_level)
signal time_changed(new_time)
signal hp_changed(new_hp)

const SAVE_PATH := "user://savegame.json"

var score: int = 0
var level: int = 1
var time: float = 0.0
var hp: int = 100

func _process(delta: float) -> void:
	time += delta
	time_changed.emit(time)

func update_hud() -> void:
	score_changed.emit(score)
	level_changed.emit(level)
	time_changed.emit(time)
	hp_changed.emit(hp)

func reset_game() -> void:
	score = 0
	level = 1
	time = 0.0
	hp = 100

func set_score(value: int) -> void:
	score = value
	emit_signal("score_changed", score)

func add_score(value: int) -> void:
	score += value
	emit_signal("score_changed", score)

func set_level(value: int) -> void:
	level = value
	emit_signal("level_changed", level)

func set_time(value: float) -> void:
	time = value
	emit_signal("time_changed", time)

func add_time(value: float) -> void:
	time += value
	emit_signal("time_changed", time)

func set_hp(value: int) -> void:
	hp = clamp(value, 0, 100)
	emit_signal("hp_changed", hp)

func reduce_hp(value: int) -> void:
	set_hp(hp - value)

func save_game() -> void:
	var save_data = {
		"score": score,
		"level": level,
		"time": time,
		"hp": hp
	}
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data))
		file.close()
		print("游戏已保存")
	else:
		print("保存失败！")
		
func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		print("没有存档文件")
		return false
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		file.close()
		var data = JSON.parse_string(content)
		if typeof(data) == TYPE_DICTIONARY:
			score = data.get("score", 0)
			level = data.get("level", 1)
			time = data.get("time", 0.0)
			hp = data.get("hp", 100)
			print("存档已加载")
			return true
		else:
			print("存档解析失败")
			return false
	else:
		print("读取失败")
		return false
