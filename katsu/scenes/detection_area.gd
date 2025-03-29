extends Area2D

var detected_bodies = []

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _on_body_entered(body):
	if body.name == "slime":
		detected_bodies.append(body)
		update_closest_body()

func _on_body_exited(body):
	if body.name == "slime" and body in detected_bodies:
		detected_bodies.remove(body)
		update_closest_body()

func update_closest_body():
	if detected_bodies.size() > 0:
		var closest_body = null
		var closest_distance = INF
		for body in detected_bodies:
			var distance = self.global_position.distance_to(body.global_position)
			if distance < closest_distance:
				closest_distance = distance
				closest_body = body
