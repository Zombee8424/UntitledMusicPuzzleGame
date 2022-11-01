extends EntityConfigButton;


func _on_pressed() -> void:
	if config_entity is Mover:
		config_entity.get_parent().queue_free();
	else:
		config_entity.queue_free();
