extends Area2D

const SPEED: float = 500.0
var direction: Vector2 = Vector2.UP

@onready var sprite: Polygon2D = $Polygon2D
@onready var lifetime: Timer = $Lifetime

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)
	lifetime.wait_time = 2.0
	lifetime.start()

func _physics_process(delta: float) -> void:
	position += direction * SPEED * delta

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("obstacle"):
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("worm_segment"):
		area.take_damage()
		queue_free()
	elif area.is_in_group("mushroom"):
		area.take_damage()
		queue_free()

func _on_lifetime_timeout() -> void:
	queue_free()