extends Node


func _on_button_button_up() -> void:
	get_tree().change_scene_to_file("res://levels/level_1.tscn")
