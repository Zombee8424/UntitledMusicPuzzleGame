class_name Beater
extends Entity


func _on_run_stop() -> void:
    call_deferred("queue_free");