extends Control

@onready var game_manager = $"/root/GameManager"
@onready var score_label = $MarginContainer/HBoxContainer/ScoreLabel
@onready var time_label = $MarginContainer/HBoxContainer/TimeLabel
@onready var hp_label = $MarginContainer/HBoxContainer/HpLabel
@onready var level_label = $MarginContainer/HBoxContainer/LevelLabel

func _ready() -> void:
	game_manager.score_changed.connect(_on_score_changed)
	game_manager.level_changed.connect(_on_level_changed)
	game_manager.time_changed.connect(_on_time_changed)
	game_manager.hp_changed.connect(_on_hp_changed)
	game_manager.update_hud()

func _on_score_changed(new_score: int) -> void:
	score_label.text = "SCORE %03d" % new_score

func _on_level_changed(new_level: int) -> void:
	level_label.text = "LEVEL %02d" % new_level

func _on_time_changed(new_time: float) -> void:
	time_label.text = "TIME %02d:%02d" % [int(new_time / 60), int(new_time) % 60]

func _on_hp_changed(new_hp: int) -> void:
	hp_label.text = "HP %03d" % new_hp
