class_name BeaterSpawn
extends Entity


export(String, FILE) var beater_path: String;


func _on_run_start() -> void:	
	var beater: Beater = load(beater_path).instance();
	assert(beater != null, "Invalid beater path");
	
	get_tree().current_scene.call_deferred("add_child", beater, true);
	assert(GameState.connect("run_stopped", beater, "_on_run_stop") == OK, "Connection Failed");
	beater.global_position = position;