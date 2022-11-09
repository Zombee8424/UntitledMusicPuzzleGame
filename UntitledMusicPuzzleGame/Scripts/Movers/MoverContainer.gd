class_name MoverContainer
extends Node2D


export var width: float;

var mover: RigidBody2D;
var end_pos: Position2D;
var cached_mover_pos: Vector2;
var cached_end_pos: Vector2;
var is_new: bool = true;
var mover_types: Dictionary = {
	"mover" : "res://Scenes/Movers/Mover.tscn",
	"bouncer" : "res://Scenes/Movers/Bouncer.tscn",
}

func _ready() -> void:
	end_pos = get_node("EndPos");

	set_cached_positions();


func _physics_process(_delta: float) -> void:
	update();

	if is_new:
		return;
	
	if mover == null or end_pos == null:
		return;
	
	if cached_mover_pos != mover.global_position or cached_end_pos != end_pos.global_position:
		mover.set_mover_position(end_pos, width);
		set_cached_positions();


func _draw() -> void:
	if mover == null:
		return;

	draw_circle(mover.position, width/2, mover.sprite.modulate);
	if !is_new:
		draw_circle(end_pos.position, width/2, mover.sprite.modulate);


func set_cached_positions() -> void:
	if mover == null or end_pos == null:
		return;
	
	cached_mover_pos = mover.global_position;
	cached_end_pos = end_pos.global_position;


func set_mover_type(mover_type: String) -> RigidBody2D:
	assert(mover_type in mover_types.keys(), "Mover Types '" + mover_type + "' Does Not Exist");

	mover = load(mover_types[mover_type]).instance();
	mover.global_position = EntityManager.get_mouse_grid_pos();
	add_child(mover, true);

	return mover;


func get_mover_mid_point() -> Vector2:
	return mover.global_position + ((end_pos.global_position - mover.global_position) / 2);