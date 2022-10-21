extends Node

var entities_enabled: bool = false setget setter_entities_enabled;
var grid_size: float;

export var node_types: Dictionary = {
	"beater_spawn" : "res://Scenes/Other/BeaterSpawn.tscn",
	"block" : "res://Scenes/Blocks/Block.tscn",
	"mover" : "res://Scenes/Movers/MoverContainer.tscn",
};
var build_node: Node2D;


func setter_entities_enabled(value: bool) -> void:
	entities_enabled = value;
	
	for entity in get_tree().get_nodes_in_group("Entities"):
		assert(entity is Entity, 'Entity "' + entity.name + '" is not of type Entity, but is in Entities group');
		entity.enabled = value;


func _ready() -> void:
	var grid_manager: Node2D = get_tree().current_scene.get_node("GridManager");
	assert(grid_manager != null, "Level missing grid manager");
	grid_size = grid_manager.grid_size;


func _physics_process(_delta: float) -> void:
	if (Input.is_action_just_pressed("space")):
		if (entities_enabled == true or (entities_enabled == false and build_node == null)):
			self.entities_enabled = !entities_enabled;
	
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
		
	build_node.modulate = Color.white;
	self.entities_enabled = false;


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
	
