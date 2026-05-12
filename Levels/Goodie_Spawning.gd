extends Node


var coin_block = load("res://Scenes/Goodies/Coin.tscn");
var up_block = load("res://Scenes/Goodies/Protein_Bar.tscn");
var coffee_block = load("res://Scenes/Goodies/Coffee.tscn");

func spawn_goodies():
	var goodie_cells = $Goodies.get_used_cells();
	for cell in goodie_cells:
		var data = $Goodies.get_cell_tile_data(cell);
		var item = data.get_custom_data("Inventory");
		match item:
			"coin":
				var coin = coin_block.instantiate();
				add_child(coin);
				coin.position = $Goodies.map_to_local(cell);
			"star":
				var coffee = coffee_block.instantiate();
				add_child(coffee);
				coffee.position = $Goodies.map_to_local(cell);
			"fire":
				pass;
			"grow":
				pass;
