extends Node2D

const GridSquare = preload("GridSquare.tscn")

export var grid_size := Vector2(10, 10)
var grid = []
var grid_charecters: Array
var grid_square_size: Vector2 = GridSquare.instance().texture.get_size()
var walls: StaticBody2D = StaticBody2D.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	__init_childrens()
	__init_grid()
			
func __init_grid() -> void:
	for i in range(grid_size.x):
		grid.append([])
		grid[i] = []
		for j in range(grid_size.y):
			var new_grid_square = GridSquare.instance()
			new_grid_square.position = Vector2(i * (grid_square_size.x - 1), j * (grid_square_size.y - 1))
			grid[i].append(new_grid_square)
			add_child(grid[i][j])
	var horizontal_wall_size = (grid_square_size.x - 1.0) * grid_size.x
	var vertical_wall_size = (grid_square_size.y - 1.0) * grid_size.y
	
	var top_wall := CollisionShape2D.new()
	top_wall.shape = RectangleShape2D.new()
	top_wall.shape.extents = Vector2(horizontal_wall_size / 2 + 1, 2)
	top_wall.position = Vector2(horizontal_wall_size / 2, -1) - (grid_square_size / 2)
	
	var bottom_wall := CollisionShape2D.new()
	bottom_wall.shape = RectangleShape2D.new()
	bottom_wall.shape.extents = Vector2(horizontal_wall_size / 2 + 1, 2)
	bottom_wall.position = Vector2(horizontal_wall_size / 2, (vertical_wall_size + 2)) - (grid_square_size / 2)
	
	var left_wall := CollisionShape2D.new()
	left_wall.shape = RectangleShape2D.new()
	left_wall.shape.extents = Vector2(2, vertical_wall_size / 2)
	left_wall.position = Vector2(-1, vertical_wall_size / 2) - (grid_square_size / 2)
	
	var right_wall := CollisionShape2D.new()
	right_wall.shape = RectangleShape2D.new()
	right_wall.shape.extents = Vector2(2, vertical_wall_size / 2)
	right_wall.position = Vector2((horizontal_wall_size + 2), vertical_wall_size / 2) - (grid_square_size / 2)
	
	walls.add_child(top_wall)
	walls.add_child(bottom_wall)
	walls.add_child(left_wall)
	walls.add_child(right_wall)
	add_child(walls)
	
		

func __init_childrens() -> void:
	grid_charecters = get_children()
	for grid_charecter in grid_charecters:
		assert(grid_charecter is GridCharecter)
		assert (grid_charecter.starting_grid_position.x >= 0 and
				grid_charecter.starting_grid_position.x < grid_size.x and
				grid_charecter.starting_grid_position.y >= 0 and
				grid_charecter.starting_grid_position.y < grid_size.y)
		grid_charecter.position = grid_charecter.starting_grid_position * (grid_square_size - Vector2(1, 1))


