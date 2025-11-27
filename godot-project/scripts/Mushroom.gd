extends Area2D

var health: int = 3

@onready var sprite: Polygon2D = $Polygon2D

func _ready() -> void:
	add_to_group("mushroom")
	area_entered.connect(_on_area_entered)

func take_damage() -> void:
	health -= 1
	if health <= 0:
		Global.add_score(50)
		queue_free()
	else:
		# Change color to show damage
		var color = Color.GREEN
		if health == 2:
			color = Color("#00cc00")
		elif health == 1:
			color = Color("#009900")
		sprite.color = color

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("worm_segment"):
		# Block worm movement
		pass