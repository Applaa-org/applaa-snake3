extends Area2D

@onready var sprite: Polygon2D = $Polygon2D
@onready var worm_parent: Node = get_parent()

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func take_damage() -> void:
	if worm_parent and worm_parent.has_method("remove_segment"):
		worm_parent.remove_segment(self)
	queue_free()

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		body.take_damage()