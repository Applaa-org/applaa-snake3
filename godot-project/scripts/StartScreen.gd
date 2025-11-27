extends Control

func _ready() -> void:
	$VBoxContainer/StartButton.pressed.connect(_on_start_pressed)
	$VBoxContainer/CloseButton.pressed.connect(_on_close_pressed)
	
	# Set up retro styling
	var style_box = StyleBoxFlat.new()
	style_box.bg_color = Color("#001100")
	$Panel.add_theme_stylebox_override("panel", style_box)

func _on_start_pressed() -> void:
	Global.reset_game()
	Global.start_game()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_close_pressed() -> void:
	get_tree().quit()