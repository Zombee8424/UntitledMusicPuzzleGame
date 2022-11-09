class_name Mover
extends Entity


signal mover_position_updated;


var sprite: Sprite;
var collider: CollisionShape2D;


func _ready() -> void:
	sprite = get_node("Sprite");
	collider = get_node("Collider");
	
	collider.shape = RectangleShape2D.new();

	
func set_mover_position(end_pos: Position2D, width: float) -> void:
	# Var Setup
	var line_length = (end_pos.position - position).length();
	var mover_scale = Vector2(line_length, width);
	var mid_point = Vector2(abs(line_length/2), 0);
	
	# Sprite Position
	sprite.scale = mover_scale;
	sprite.position = mid_point; # Sets the sprite to halfway between root and endpoint
	
	# Collider Position
	collider.shape.extents = mover_scale/2;
	collider.position = mid_point;
	
	# Rotation
	look_at(end_pos.global_position);
	
	emit_signal("mover_position_updated");