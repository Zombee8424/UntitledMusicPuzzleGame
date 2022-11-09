extends CanvasLayer


var config_menu: VBoxContainer;
export var config_buttons: Dictionary = {
	"delete" : "res://Scenes/UI/EntityConfigButtons/EntityConfig_Delete.tscn",
	"flip_direction" : "res://Scenes/UI/EntityConfigButtons/EntityConfig_FlipDirection.tscn",
};


func _ready() -> void:
	config_menu = get_node("ConfigMenu");


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("right_click") and !GameState.is_run_active and EntityManager.build_node == null:
		var entities_at_mouse_pos = ClickDetector.get_entities_at_mouse_position();
		close_config_menu();
		if len(entities_at_mouse_pos) > 0:
			var config_entity = entities_at_mouse_pos[0];
			open_config_menu(config_entity);


func open_config_menu(config_entity: Entity) -> void:
	config_menu.set_global_position(get_viewport().get_mouse_position());

	for config_option in config_entity.config_options:
		assert(config_option in config_buttons.keys(), "Configuration option '" + config_option + "' does not exist");

		var config_button = load(config_buttons[config_option]).instance();
		config_menu.add_child(config_button, true);

		config_button.config_entity = config_entity;

		assert(config_button.connect("pressed", self, "close_config_menu") == OK, "Connection Failed");


func close_config_menu() -> void:
	config_menu.set_global_position(Vector2.ZERO);

	for child in config_menu.get_children():
		child.queue_free();
