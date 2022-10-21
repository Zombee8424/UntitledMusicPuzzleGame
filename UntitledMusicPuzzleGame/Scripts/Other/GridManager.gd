extends Node2D

export var grid_size: float = 32;
export var grid_line_size: float = 2;
export var grid_line_colour: Color = Color.darkgray;


func _draw() -> void:
	var screen_size: Vector2 = get_tree().get_nodes_in_group("Camera")[0].position * 2;
	
	draw_rect(Rect2(Vector2.ZERO, screen_size), Color.gray, true);
	
	for h_line_pos in range(0, screen_size.x, grid_size):
		draw_line(Vector2(h_line_pos, 0), Vector2(h_line_pos, screen_size.y), grid_line_colour, grid_line_size);
	
	for v_line_pos in range(0, screen_size.y, grid_size):
		draw_line(Vector2(0, v_line_pos), Vector2(screen_size.x, v_line_pos), grid_line_colour, grid_line_size);


func _physics_process(delta: float) -> void:
	update();
