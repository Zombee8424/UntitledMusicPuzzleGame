extends Entity
class_name Beater


func setter_enabled(value: bool) -> void:
	enabled = value;
	
	if (value == false):
		call_deferred("queue_free");
