extends Entity
class_name BeaterSpawn


export(String, FILE) var beater_path: String;


func setter_enabled(value: bool) -> void:
	.setter_enabled(value);

	if (enabled == true):
		var beater: Beater = load(beater_path).instance();
		get_tree().current_scene.call_deferred("add_child", beater, true);
		beater.global_position = position;
