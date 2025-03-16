extends Area2D

var direction: Vector2
const SPEED = 250

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("FIREBALL!")
	var angle = randf() * TAU
	direction = Vector2(cos(angle), sin(angle))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	move_local_x(direction[0])
	move_local_y(direction[1])
