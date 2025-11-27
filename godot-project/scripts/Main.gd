extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var worm: Node2D = $Worm
@onready var score_label: Label = $UI/ScoreLabel
@onready var high_score_label: Label = $UI/HighScoreLabel

func _ready() -> void:
	# Connect score updates
	Global.score_changed.connect(_on_score_changed)
	
	# Set initial UI
	score_label.text = "SCORE: %d" % Global.score
	high_score_label.text = "HI-SCORE: %d" % Global.high_score
	
	# Position player at bottom center
	var screen_size = get_viewport().get_visible_rect().size
	player.position = Vector2(screen_size.x / 2, screen_size.y - 50)
	
	# Position worm at top
	worm.position = Vector2(screen_size.x / 2, 50)

func _on_score_changed(new_score: int) -> void:
	score_label.text = "SCORE: %d" % new_score
	high_score_label.text = "HI-SCORE: %d" % Global.high_score

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/StartScreen.tscn")