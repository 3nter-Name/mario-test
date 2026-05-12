extends Control


func _on_quit_pressed() -> void:
	get_tree().quit(0);


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Story/Story01.tscn");
