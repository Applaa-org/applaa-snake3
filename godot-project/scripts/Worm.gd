extends Node2D

const SEGMENT_SCENE: PackedScene = preload("res://scenes/WormSegment.tscn")
const MUSHROOM_SCENE: PackedScene = preload("res://scenes/Mushroom.tscn")

var segments: Array[Node] = []
var direction: Vector2 = Vector2.RIGHT
var speed: float = 100.0
var segment_spacing: float = 20.0

@onready var move_timer: Timer = $MoveTimer

func _ready() -> void:
	move_timer.wait_time = 0.05
	move_timer.timeout.connect(_on_move_timer)
	
	# Create initial segments
	for i in range(12):
		var segment = SEGMENT_SCENE.instantiate()
		add_child(segment)
		segments.append(segment)
		segment.position = Vector2(-i * segment_spacing, 0)
		segment.add_to_group("worm_segment")
	
	move_timer.start()

func _on_move_timer() -> void:
	if not Global.game_active:
		return
	
	# Move head
	if segments.size() > 0:
		var head = segments[0]
		var new_pos = head.position + direction * speed * move_timer.wait_time
		
		# Bounce off walls
		var screen_size = get_viewport().get_visible_rect().size
		if new_pos.x <= 20 or new_pos.x >= screen_size.x - 20:
			direction.x *= -1
			new_pos.y += 30  # Move down when hitting wall
		
		# Check if reached bottom
		if new_pos.y >= screen_size.y - 50:
			Global.end_game(false)
			get_tree().change_scene_to_file("res://scenes/DefeatScreen.tscn")
			return
		
		head.position = new_pos
		
		# Move following segments
		for i in range(1, segments.size()):
			var target = segments[i-1].position
			var current = segments[i].position
			var diff = target - current
			
			if diff.length() > segment_spacing:
				var move_dir = diff.normalized()
				segments[i].position = target - move_dir * segment_spacing

func remove_segment(segment: Node) -> void:
	var index = segments.find(segment)
	if index != -1:
		segments.erase(segment)
		Global.add_score(100)
		
		# Chance to spawn mushroom
		if randf() < 0.3:
			var mushroom = MUSHROOM_SCENE.instantiate()
			get_tree().current_scene.add_child(mushroom)
			mushroom.global_position = segment.global_position
		
		# Check victory
		if segments.size() <= 0:
			Global.end_game(true)
			get_tree().change_scene_to_file("res://scenes/VictoryScreen.tscn")