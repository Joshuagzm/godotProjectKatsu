extends CharacterBody2D

const SPEED = 400.0
const ACCELERATION = 50
const FOCUS_SPEED = 200.0
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

func _physics_process(delta: float) -> void:
	
	var maxSpeed = FOCUS_SPEED if Input.is_action_pressed("focus") else SPEED;
	
	var direction_x := Input.get_axis("left", "right")
	if direction_x:
		velocity.x = move_toward(velocity.x, direction_x * maxSpeed, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, maxSpeed)
		
	var direction_y := Input.get_axis("up", "down")
	if direction_y:
		velocity.y = move_toward(velocity.y, direction_y * maxSpeed, ACCELERATION)
	else:
		velocity.y = move_toward(velocity.y, 0, maxSpeed)
		
	if (velocity.x != 0):
		sprite_2d.animation = "running"
	else: 
		sprite_2d.animation = "idle"

	move_and_slide()
	
	if (velocity.x < 0):
		sprite_2d.flip_h = true
	elif (velocity.x > 0):
		sprite_2d.flip_h = false
			
		
	
