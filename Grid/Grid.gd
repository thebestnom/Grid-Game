extends Node2D

export var grid_size := Vector2(10, 10)
var grid_charecters: Array
var walls: StaticBody2D = StaticBody2D.new()

enum TILES {blocking, grid, attack}

func _ready() -> void:
	__init_grid()
	__init_childrens()
			
func __init_grid() -> void:
	for i in range(grid_size.x):
		$GridTileMap.set_cell(i + 1, 0, TILES.blocking)
		$GridTileMap.set_cell(i + 1, grid_size.y + 1, TILES.blocking)
	for j in range(grid_size.y):
		$GridTileMap.set_cell(0, j + 1, TILES.blocking)
		$GridTileMap.set_cell(grid_size.x + 1, j + 1, TILES.blocking)
		
	for i in range(grid_size.x):
		for j in range(grid_size.y):
			$GridTileMap.set_cell(i + 1, j + 1, TILES.grid)
	
		

func __init_childrens() -> void:
	grid_charecters = get_children()
	for grid_charecter in grid_charecters:
		assert(grid_charecter is GridCharecter or grid_charecter == $GridTileMap)
		if grid_charecter is GridCharecter:
			if OS.is_debug_build():
				var starting_poision: int = $GridTileMap.get_cellv(grid_charecter.starting_grid_position + Vector2(1, 1))
				assert (starting_poision != -1 and starting_poision != TILES.blocking)
			grid_charecter.position = \
				$GridTileMap.map_to_world(grid_charecter.starting_grid_position + Vector2(1, 1)) \
					+ $GridTileMap.cell_size / 2
			grid_charecter.connect("attack", self, "_attack_listener", [grid_charecter])
					
func _attack_listener(position: Vector2, _grid_charecter: GridCharecter) -> void:
	var cell_to_attack: Vector2 = $GridTileMap.world_to_map(position)
	var cell_type: int = $GridTileMap.get_cellv(cell_to_attack)
	if cell_type == TILES.grid:
		$GridTileMap.set_cellv(cell_to_attack, TILES.attack)
		yield(get_tree().create_timer(1.0), "timeout")
		$GridTileMap.set_cellv(cell_to_attack, TILES.grid)	

