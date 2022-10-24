extends Node

var grid_size: float;

export var node_types: Dictionary = {
	"beater_spawn" : "res://Scenes/Other/BeaterSpawn.tscn",
	"block" : "res://Scenes/Blocks/Block.tscn",
	"mover" : "res://Scenes/Movers/MoverContainer.tscn",
};
var build_node: Node2D;


func _ready() -> void:
	var grid_manager: Node2D = get_tree().current_scene.get_node("GridManager");
	assert(grid_manager != null, "Level missing grid manager");
	grid_size = grid_manager.grid_size;
	
	assert(GameState.connect("run_started", self, "_on_run_start") == OK, "Connection Failed");
	assert(GameState.connect("run_stopped", self, "_on_run_stop") == OK, "Connection Failed");


func _physics_process(_delta: float) -> void:
	if (build_node != null):
		build_node.global_position = get_mouse_grid_pos();
		
		if (Input.is_action_just_pressed("left_click")):
			if (!is_entity_at_position(build_node.global_position)):
				if (build_node is Mover and build_node.is_new == true):
					build_node.is_new = false;
					set_build_node(build_node.get_parent().end_pos, "", false);
				else:
					build_node = null;
	else:
		if (Input.is_key_pressed(KEY_1)):
			set_build_node(null, "beater_spawn");
		elif (Input.is_key_pressed(KEY_2)):
			set_build_node(null, "block");
		elif (Input.is_key_pressed(KEY_3)):
			set_build_node(null, "mover");
		else:
			return;
			
		GameState.is_run_active = false;


func _on_run_start() -> void:
	for entity in get_tree().get_nodes_in_group("Entities"):
		if entity is BeaterSpawn:
			entity.spawn_beater();


func _on_run_stop() -> void:
	for entity in get_tree().get_nodes_in_group("Entities"):
		if entity is Beater:
			entity.call_deferred("queue_free");


func set_build_node(node: Node2D = null, node_type: String = "", create_node: bool = true) -> void:
	if (create_node == true):
		assert(node == null and node_type != "", "Invalid parameters for creating node");
		node = load(node_types[node_type]).instance();
		get_tree().current_scene.call_deferred("add_child", node, true);
	
	if (node is MoverContainer):
		node.global_position = get_mouse_grid_pos();
		build_node = node.get_node("Mover");
	else:
		node.global_position = get_mouse_grid_pos();
		build_node = node;


func is_entity_at_position(check_position: Vector2) -> bool:
	assert(build_node != null, "Build node is null");
	
	for entity in get_tree().get_nodes_in_group("Entities"):
		if (entity is Mover or build_node is Mover or build_node.get_parent() is MoverContainer):
			continue;
		
		if (entity != build_node && entity.global_position == check_position):
			return true;
	return false;


func get_mouse_grid_pos() -> Vector2:
	var mouse_pos = get_viewport().get_mouse_position();
	return Vector2(
		stepify(mouse_pos.x - grid_size/2, grid_size) + grid_size/2,
		stepify(mouse_pos.y - grid_size/2, grid_size) + grid_size/2
	);
	
