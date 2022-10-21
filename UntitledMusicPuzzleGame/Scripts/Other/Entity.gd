extends RigidBody2D
class_name Entity

var enabled: bool = false setget setter_enabled;


func setter_enabled(value: bool) -> void:
	enabled = value;
	
	for child in get_children():
		if (child is CollisionShape2D or child is CollisionPolygon2D):
			child.disabled = !value;
