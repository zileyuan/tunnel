extends Node

@onready var player: AudioStreamPlayer = AudioStreamPlayer.new()

func _ready():
	add_child(player)
	player.bus = "Music"  # 记得在 Audio 面板里建一个 "Music" 总线

func _play_intro():
	player.stream = load("res://assets/sounds/intro.ogg")
	player.play()

func _play_game():
	player.stream = load("res://assets/sounds/game.ogg")
	player.play()
	
func _play_pause():
	player.stream = load("res://assets/sounds/over.ogg")
	player.play()
	
func _play_over():
	player.stream = load("res://assets/sounds/over.ogg")
	player.play()

func switch_to_game_music():
	var tween = create_tween()
	tween.tween_property(player, "volume_db", -80, 1.0) # 1 秒淡出
	tween.tween_callback(Callable(self, "_play_game"))
	tween.tween_property(player, "volume_db", 0, 1.0)

func switch_to_pause_music():
	var tween = create_tween()
	tween.tween_property(player, "volume_db", -80, 1.0) # 1 秒淡出
	tween.tween_callback(Callable(self, "_play_pause"))
	tween.tween_property(player, "volume_db", 0, 1.0)
	
func switch_to_intro_music():
	var tween = create_tween()
	tween.tween_property(player, "volume_db", -80, 1.0) # 1 秒淡出
	tween.tween_callback(Callable(self, "_play_intro"))
	tween.tween_property(player, "volume_db", 0, 1.0)
	
func switch_to_over_music():
	var tween = create_tween()
	tween.tween_property(player, "volume_db", -80, 1.0) # 1 秒淡出
	tween.tween_callback(Callable(self, "_play_over"))
	tween.tween_property(player, "volume_db", 0, 1.0)   # 1 秒淡入
