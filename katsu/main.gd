extends Node

@export var mob_scene: PackedScene

var score = 0
const MAX_SCORE = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var gui_node = get_node("gui/healthContainer")
	var mainCharacter_node = get_node("MainCharacter")
	mainCharacter_node.connect("main_character_damaged", gui_node.update_health)
	gui_node.update_health(4)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Score.text = "{score}/{max_score}".format({"score": score, "max_score": MAX_SCORE})
	pass


func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate();
	
#	spawn at the some place
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	mob.position = mob_spawn_location.position
	mob.set_deferred("collision_layer", 1)
	mob.set_deferred("collision_mask", 1)
	mob.add_to_group("slime")
	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
	mob.connect("slime_die", update_score)
	


func _on_start_timer_timeout() -> void:
	print("STARTING")
	$MobTimer.start()


func update_health():
	print("updating damage")
	

func update_score():
	score += 1
	print("SCORE UPDATED")
	if (score >= 10):
		get_tree().change_scene_to_file("res://scenes/win_screen.tscn")
