extends Node

signal score_changed(new_score: int)
signal game_over(victory: bool)

var score: int = 0
var high_score: int = 0
var game_active: bool = false

func add_score(points: int) -> void:
	score += points
	score_changed.emit(score)
	if score > high_score:
		high_score = score

func reset_game() -> void:
	score = 0
	game_active = false
	score_changed.emit(score)

func start_game() -> void:
	game_active = true

func end_game(victory: bool) -> void:
	game_active = false
	game_over.emit(victory)