extends Control

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	self.visible = false
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		if self.visible:
			self.hide_pause_menu()
		else:
			self.show_pause_menu()

func show_pause_menu() -> void:
	self.visible = true
	get_tree().paused = true
	
func hide_pause_menu() -> void:
	self.visible = false
	get_tree().paused = false

func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	get_tree().quit();

func _on_resume_button_pressed() -> void:
	hide_pause_menu()
