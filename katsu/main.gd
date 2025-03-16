extends Node

@export var mob_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("hello world")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate();
	
#	spawn at the some place
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	mob.position = mob_spawn_location.position

	# Spawn the mob by adding it to the Main scene.
	print("ADDING SLIME")
	add_child(mob)


func _on_start_timer_timeout() -> void:
	print("STARTING")
	$MobTimer.start()
