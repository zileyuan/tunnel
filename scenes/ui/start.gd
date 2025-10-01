extends Control

@onready var loading_manager = $"/root/LoadingManager"
@onready var bgm_manager = $"/root/BgmManager"
@onready var game_manager = $"/root/GameManager"

@onready var new_game_button = $CenterContainer/RootVBox/ButtonsVBox/NewGameButton
@onready var load_game_button = $CenterContainer/RootVBox/ButtonsVBox/LoadGameButton
@onready var quit_button = $CenterContainer/RootVBox/ButtonsVBox/QuitButton
@onready var progress_bar = $CenterContainer/RootVBox/ProgressBar

func _ready() -> void:
	get_tree().paused = false;
	set_process_input(true);
	loading_manager.load_progress_updated.connect(_on_load_progress_updated)
	loading_manager.load_finished.connect(_on_load_finished)
	bgm_manager.switch_to_intro_music()
	
func _on_load_progress_updated(progress: float) -> void:
	progress_bar.value = progress * 100

func _on_load_finished() -> void:
	new_game_button.disabled = false
	load_game_button.disabled = false
	quit_button.disabled = false
	progress_bar.modulate.a = 0
	loading_manager.enter_main()
	
func _on_new_game_button_pressed() -> void:
	new_game_button.disabled = true
	load_game_button.disabled = true
	quit_button.disabled = true
	progress_bar.modulate.a = 255
	loading_manager.start_load_main()

func _on_load_game_button_pressed() -> void:
	new_game_button.disabled = true
	load_game_button.disabled = true
	quit_button.disabled = true
	progress_bar.modulate.a = 255
	if game_manager.load_game():
		loading_manager.start_load_main()

func _on_quit_button_pressed() -> void:
	get_tree().quit();
