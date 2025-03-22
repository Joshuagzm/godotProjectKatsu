extends CharacterBody2D

@export var bullet_scene: PackedScene

const SPEED = 150.0
const ACCELERATION = 5

var playerBody: CharacterBody2D
var moving: bool
var direction: Vector2

enum states {IDLE, FIRING, MOVING}
var state: states
var health = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_as_top_level(true)
	state = states.IDLE

func _physics_process(delta: float) -> void:
	if (playerBody && state == states.IDLE):
		direction = (playerBody.global_position - global_position).normalized()
		
	if (state == states.MOVING):
		velocity.x = move_toward(velocity.x, direction[0] * SPEED, ACCELERATION)
		velocity.y = move_toward(velocity.y, direction[1] * SPEED, ACCELERATION)
		move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("Slime ded")

func _on_detection_area_body_entered(body: Node2D) -> void:
	if ("MainCharacter" in body.name):
		playerBody = body
	

func _on_start_timer_timeout() -> void:
	state = states.FIRING
	$FiringCooldownTimer.start()
	$FiringTimer.start()

func _on_firing_timer_timeout() -> void:
	state = states.IDLE
	$MovingTimer.start()

func _on_moving_timer_timeout() -> void:
	state = states.MOVING


func _on_firing_cooldown_timer_timeout() -> void:
	if (state != states.FIRING):
		$FiringCooldownTimer.stop()
	else: 
		var bullet = bullet_scene.instantiate()
		bullet.top_level = true
		bullet.global_position = global_position
		add_child(bullet)

func hit() -> void:
	health -= 1
	if (health <= 0):
		die()
		
func die() -> void:
	slime_die.emit()
	queue_free()
	
signal slime_die()
