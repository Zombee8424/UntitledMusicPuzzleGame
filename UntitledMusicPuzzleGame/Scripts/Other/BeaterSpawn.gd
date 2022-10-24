class_name BeaterSpawn
extends Entity


export(String, FILE) var beater_path: String;


func spawn_beater() -> void:	
	var beater: Beater = load(beater_path).instance();
	assert(beater != null, "Invalid beater path");
	
	get_tree().current_scene.call_deferred("add_child", beater, true);
	beater.global_position = position;