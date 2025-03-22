extends CharacterBody2D

const SPEED = 400.0
const ACCELERATION = 50
const FOCUS_SPEED = 200.0

# stats
var firing = false;
var health = 4

# supplementary
var slimes = []

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var detection_area = $DetectionArea  # Replace with your detection area node

var player_bullet_scene = preload("res://scenes/bullet.tscn")

func _ready():
	detection_area.connect("body_entered",_on_body_entered)
	detection_area.connect("body_exited", _on_body_exited)

func _process(delta: float) -> void:
	if Input.is_action_pressed("fire"):
		if $ShootTimer.is_stopped():
			firing = true
			print("FIRING BULLET")
			shoot_bullet()
			$ShootTimer.start()

func _physics_process(delta: float) -> void:

	var maxSpeed = FOCUS_SPEED if Input.is_action_pressed("focus") else SPEED;

	var direction_x := Input.get_axis("left", "right")
	if direction_x:
		if (velocity.x * direction_x < 0):
			velocity.x = 0 
		velocity.x = move_toward(velocity.x, direction_x * maxSpeed, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, maxSpeed)

	var direction_y := Input.get_axis("up", "down")
	if direction_y:
	# Snap reverse direction
		if (velocity.y * direction_y < 0):
			velocity.y = 0 
		velocity.y = move_toward(velocity.y, direction_y * maxSpeed, ACCELERATION)
	else:
		velocity.y = move_toward(velocity.y, 0, maxSpeed)

	if (velocity.x != 0 || velocity.y != 0):
		sprite_2d.animation = "running"
	else: 
		sprite_2d.animation = "idle"

	move_and_slide()

	if (velocity.x < 0):
		sprite_2d.flip_h = true
	elif (velocity.x > 0):
		sprite_2d.flip_h = false

func take_damage(damage_value):
	health -= damage_value
	var format_string = "hit, health remaining: %s"
	print(format_string % health)
	main_character_damaged.emit(health)
	if health <= 0:
		die()

func die():
	print("Player has died")
	get_tree().change_scene_to_file("res://levels/death.tscn")

func reset():
	health = 4

signal main_character_damaged(amount)

func _on_body_entered(body: Node2D):
	if (body.is_in_group("slime")):
		slimes.append(body)
		print("appending slime")

func _on_body_exited(body: Node2D):
	if body.is_in_group("slime"):
		slimes.erase(body)

func get_closest_slime():
	var closest_slime = null
	var closest_distance = INF
	for slime in slimes:
		var distance = global_position.distance_to(slime.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_slime = slime
	return closest_slime

func shoot_bullet():
	var closest_slime = get_closest_slime()
	if closest_slime:
		var direction = (closest_slime.global_position - global_position).normalized()
		var bullet_instance = player_bullet_scene.instantiate()
		bullet_instance.top_level = true
		bullet_instance.global_position = global_position
		bullet_instance.initialize(direction)  # Pass the direction to the bullet
		bullet_instance.add_to_group("player_bullets")
		add_child(bullet_instance)
	else:
		print("No slimes detected!")
