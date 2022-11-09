extends EntityConfigButton


func _on_pressed() -> void:
    assert(config_entity.has_method("flip_direction"), "Entity has no 'flip_direction' method");
    config_entity.flip_direction();

