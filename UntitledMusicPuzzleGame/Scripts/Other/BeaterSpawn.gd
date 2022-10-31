class_name BeaterSpawn
extends Entity


export(String, FILE) var beater_path: String;


func _on_run_start() -> void:
	# Spawn Beater	
	var beater: Beater = load(beater_path).instance();
	assert(beater != null, "Invalid beater path");
	
	get_tree().current_scene.call_deferred("add_child", beater, true);

	# call_deferred always returns null so manually checked if the connection will succeed
	if beater.has_method("_on_run_stop") and !GameState.is_connected("run_stopped", beater, "_on_run_stop"):
		GameState.call_deferred("connect", "run_stopped", beater, "_on_run_stop");
	else:
		assert(false, "Connection Failed");

	beater.global_position = position;

	# Disable Collider
	get_node("Collider").disabled = true;

	# Set Opacity
	modulate = Color(1, 1, 1, 0.4);


func _on_run_stop() -> void:
	# Enable Collider
	get_node("Collider").disabled = false;
	
	# Set Opacity
	modulate = Color(1, 1, 1, 1);