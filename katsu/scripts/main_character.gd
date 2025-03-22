extends CharacterBody2D

const SPEED = 400.0
const ACCELERATION = 50
const FOCUS_SPEED = 200.0
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

var health = 4

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
	if health <= 0:
		die()

func die():
	print("Player has died")
	get_tree().change_scene_to_file("res://levels/death.tscn")

func reset():
	health = 4
