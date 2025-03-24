extends Area2D

var direction: Vector2
const SPEED = 250
var active = true;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var angle = randf() * TAU
	direction = Vector2(cos(angle), sin(angle))
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	move_local_x(direction[0])
	move_local_y(direction[1])


func _on_body_entered(body: Node2D) -> void:
	if ("MainCharacter" in body.name):
		body.take_damage(1)
		queue_free()



func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
