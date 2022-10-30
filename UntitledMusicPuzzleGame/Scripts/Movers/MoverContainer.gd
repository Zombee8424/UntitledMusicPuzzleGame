class_name MoverContainer
extends Node2D


export var width: float;

var mover: RigidBody2D;
var end_pos: Position2D;
var cached_mover_pos: Vector2;
var cached_end_pos: Vector2;


func _ready() -> void:
	mover = get_node("Mover");
	end_pos = get_node("EndPos");
	
	mover.set_mover_position(end_pos, width);
	set_cached_positions();


func _physics_process(_delta: float) -> void:
	if mover.is_new == true:
		return;
	
	if mover == null or end_pos == null:
		return;
	
	if cached_mover_pos != mover.global_position or cached_end_pos != end_pos.global_position:
		mover.set_mover_position(end_pos, width);
		set_cached_positions();


func set_cached_positions() -> void:
	if mover == null or end_pos == null:
		return;
	
	cached_mover_pos = mover.global_position;
	cached_end_pos = end_pos.global_position;