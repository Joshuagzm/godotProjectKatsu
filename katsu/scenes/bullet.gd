extends Area2D

var direction: Vector2
const SPEED = 500
var active = true;

func initialize(new_direction):
	direction = new_direction

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	position += direction * SPEED * delta


func _on_body_entered(body: Node2D) -> void:
	if (body.is_in_group("slime")):
		print("SLIMT IS HIT")
		body.hit()
		queue_free();
