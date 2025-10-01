extends Control

@onready var loading_manager = $"/root/LoadingManager"
@onready var bgm_manager = $"/root/BgmManager"

func _ready() -> void:
	get_tree().paused = false;
	set_process_input(true);
	bgm_manager.switch_to_over_music()

func _on_return_menu_button_pressed() -> void:
	loading_manager.enter_start()

func _on_quit_button_pressed() -> void:
	get_tree().quit();
