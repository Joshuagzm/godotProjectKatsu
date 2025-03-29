extends CharacterBody2D

const SPEED = 200.0
const ACCELERATION = 25
const FOCUS_SPEED = 100.0

# stats
var firing = false;
var health = 4

# supplementary
var slimes = []

# states
enum HITSTATE {NEUTRAL, INVINCIBLE}
var hitState = HITSTATE.NEUTRAL


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
		changeAnimation("running")
	else: 
		changeAnimation("idle")

	move_and_slide()

	if (velocity.x < 0):
		sprite_2d.flip_h = true
	elif (velocity.x > 0):
		sprite_2d.flip_h = false

func take_damage(damage_value):
	if(hitState != HITSTATE.INVINCIBLE):
		$InvincibilityTimer.start(1)
		hitState = HITSTATE.INVINCIBLE
		changeAnimation("invincible", 1)
		health -= damage_value
		var format_string = "hit, health remaining: %s"
		main_character_damaged.emit(health)
		if health <= 0:
			die()

func die():
	get_tree().change_scene_to_file("res://levels/death.tscn")

func reset():
	health = 4

signal main_character_damaged(amount)

func _on_body_entered(body: Node2D):
	if (body.is_in_group("slime")):
		slimes.append(body)

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
	var direction = Vector2(1, 0);
	var closest_slime = get_closest_slime()
	if closest_slime:
		direction = (closest_slime.global_position - global_position).normalized()
	var bullet_instance = player_bullet_scene.instantiate()
	bullet_instance.global_position = global_position
	bullet_instance.initialize(direction)
	bullet_instance.add_to_group("player_bullets")
	get_parent().add_child(bullet_instance)

func changeAnimation(animation: String, lockDuration: int = 0):
	if $AnimationTimer.is_stopped():
		if (lockDuration > 0):
			$AnimationTimer.start(lockDuration)
		print("Playing animation")
		sprite_2d.animation = animation
		

func _on_invincibility_timer_timeout() -> void:
	hitState = HITSTATE.NEUTRAL

func _on_animation_timer_timeout() -> void:
	pass # Replace with function body.
