extends Control

@onready var progress_bar = $VBoxContainer/ProgressBar

func _ready() -> void:
	self.visible = false

func _on_load_progress_updated(progress: float) -> void:
	progress_bar.value = progress * 100

func _on_load_finished() -> void:
	self.visible = false
