extends Node2D

func _ready() -> void:
	$Player.position = $Spawnpoint.position;
	set_camera_limits();
#	spawn_goodies();
	spawn_enemies();
	$Geese.hide();

func set_camera_limits():
	var map_size = $Enviroment.get_used_rect();
	var cell_size = $Enviroment.tile_set.tile_size;
	$Player/Camera2D.limit_left = (map_size.position.x - 5) * cell_size.x;
	$Player/Camera2D.limit_right = (map_size.end.x + 5) * cell_size.x;
	$Player/Camera2D.limit_top = 0;


var goose_scene = load("res://Scenes/Goose.tscn");

func spawn_enemies():
	var goose_cells = $Geese.get_used_cells();
	for cell in goose_cells:
		var goose = goose_scene.instantiate();
		add_child(goose);
		goose.position = $Geese.map_to_local(cell);

func _on_player_respawn() -> void:
	$Player.position = $Spawnpoint.position;


func _on_player_died() -> void:
	get_tree().change_scene_to_file("res://Scenes/Story/story_died.tscn");


func _on_area_2d_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://Scenes/Story/Story02.tscn");
