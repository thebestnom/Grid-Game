extends GridCharecter

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var did_move := false

export var start_move_speed := 200.0
var move_speed := start_move_speed
export var accelerate_speed := 1.01
export var max_speed = 250.0

var last_position: Vector2

func _physics_process(delta):
	if not did_move:
		move_speed = start_move_speed
	
	var move_direction := Vector2(0, 0)
	if Input.is_action_pressed("PlayerUp"):
		move_direction += Vector2(0, -1)
	if Input.is_action_pressed("PlayerDown"):
		move_direction += Vector2(0, 1)
	if Input.is_action_pressed("PlayerLeft"):
		move_direction += Vector2(-1, 0)
	if Input.is_action_pressed("PlayerRight"):
		move_direction += Vector2(1, 0)
	
	if move_direction != Vector2(0, 0):
		move_and_collide(move_direction * move_speed * delta)
		did_move = true
		if move_speed * accelerate_speed > max_speed:
			move_speed = max_speed
		else:
			move_speed *= accelerate_speed
		
	else:
		did_move = false

func wall_entered():
	self.position = last_position
	did_move = false

