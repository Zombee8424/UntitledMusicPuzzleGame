extends Node


signal run_started;
signal run_stopped;

var is_run_active: bool = false setget set_is_run_active;


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("space"):
		if EntityManager.build_node != null:
			return;
		
		self.is_run_active = !is_run_active;


func set_is_run_active(value: bool) -> void:
	is_run_active = value;
	
	if is_run_active:
		emit_signal("run_started");
	else:
		emit_signal("run_stopped");