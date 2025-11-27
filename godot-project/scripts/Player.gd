extends CharacterBody2D

const SPEED: float = 300.0
const BULLET_SCENE: PackedScene = preload("res://scenes/Bullet.tscn")

@onready var sprite: Polygon2D = $Polygon2D
@onready var shoot_cooldown: Timer = $ShootCooldown

func _ready() -> void:
	shoot_cooldown.wait_time = 0.3

func _physics_process(delta: float) -> void:
	if not Global.game_active:
		return
	
	# Movement
	var direction := Vector2.ZERO
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		direction.x -= 1
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		direction.x += 1
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		direction.y -= 1
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		direction.y += 1
	
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = direction * SPEED
		
		# Rotate triangle to face movement direction
		var angle = direction.angle() + PI/2
		sprite.rotation = angle
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
	
	# Keep player in bounds
	var screen_size = get_viewport().get_visible_rect().size
	position.x = clamp(position.x, 20, screen_size.x - 20)
	position.y = clamp(position.y, 20, screen_size.y - 20)
	
	# Shooting
	if Input.is_key_pressed(KEY_SPACE) and shoot_cooldown.is_stopped():
		shoot()
		shoot_cooldown.start()

func shoot() -> void:
	var bullet = BULLET_SCENE.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = global_position
	bullet.direction = Vector2.UP.rotated(sprite.rotation - PI/2)

func take_damage() -> void:
	Global.end_game(false)
	get_tree().change_scene_to_file("res://scenes/DefeatScreen.tscn")