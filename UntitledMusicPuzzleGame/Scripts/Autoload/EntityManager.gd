extends Node


var grid_size: float;
var node_types: Dictionary = {
	"beater_spawn" : "res://Scenes/Other/BeaterSpawn.tscn",
	"block" : "res://Scenes/Blocks/Block.tscn",
	"mover" : "res://Scenes/Movers/MoverContainer.tscn",
};
var build_node: Node2D;
	

func _ready() -> void:
	var grid_manager: Node2D = get_tree().current_scene.get_node("GridManager");
	assert(grid_manager != null, "Level missing grid manager");
	grid_size = grid_manager.grid_size;


func _physics_process(_delta: float) -> void:
	if build_node != null:
		build_node.global_position = get_mouse_grid_pos();
		
		if Input.is_action_just_pressed("left_click"):
			if is_build__pos_valid():
				place_build_node();
		elif Input.is_key_pressed(KEY_ESCAPE):
			if build_node.get_parent() is MoverContainer:
				build_node.get_parent().queue_free();
			else:
				build_node.queue_free();
			build_node = null;
	else:			
		if Input.is_key_pressed(KEY_1):
			set_build_node(null, "beater_spawn");
		elif Input.is_key_pressed(KEY_2):
			set_build_node(null, "block");
		elif Input.is_key_pressed(KEY_3):
			set_build_node(null, "mover");
		else:
			return;
			
		GameState.is_run_active = false;


func set_build_node(node: Node2D = null, node_type: String = "", create_node: bool = true) -> void:
	if create_node == true:
		assert(node == null and node_type != "", "Invalid parameters for creating node");
		node = load(node_types[node_type]).instance();
		get_tree().current_scene.call_deferred("add_child", node, true);
	
	if node is MoverContainer:
		node.global_position = Vector2.ZERO;
		build_node = node.get_node("Mover");
		build_node.global_position = get_mouse_grid_pos()
	else:
		node.global_position = get_mouse_grid_pos();
		build_node = node;


func place_build_node() -> void:
	if build_node is Mover:
		var parent = build_node.get_parent();
		if parent.is_new:
			parent.is_new = false;
			set_build_node(parent.end_pos, "", false);
	else:
		if build_node is BeaterSpawn:
			assert(GameState.connect("run_started", build_node, "_on_run_start") == OK, "Connection Failed");
			assert(GameState.connect("run_stopped", build_node, "_on_run_stop") == OK, "Connection Failed");

		build_node = null;


func is_build__pos_valid() -> bool:
	var test_node = build_node;
	if test_node is Position2D and test_node.get_parent() is MoverContainer:
		test_node = test_node.get_parent().mover;
	
	test_node = test_node as RigidBody2D;
	test_node.contact_monitor = true;
	
	if len(test_node.get_colliding_bodies()) == 0:
		return true;
	else:
		if test_node is Mover or (test_node is Position2D and test_node.get_parent() is MoverContainer):
			for col_body in test_node.get_colliding_bodies():
				if !(col_body is Mover or (col_body is Position2D and test_node.get_parent() is MoverContainer)):
					return false; # If build_node is mover and any of the colliding bodies are non-mover entities
			return true; # If build_node is mover and all colliding bodies are also movers

	return false;


func get_mouse_grid_pos() -> Vector2:
	var mouse_pos = get_viewport().get_mouse_position();
	return Vector2(
		stepify(mouse_pos.x - grid_size/2, grid_size) + grid_size/2,
		stepify(mouse_pos.y - grid_size/2, grid_size) + grid_size/2
	);
