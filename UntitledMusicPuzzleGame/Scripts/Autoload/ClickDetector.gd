extends Node


var mouse_follower_scene: PackedScene = preload("res://Scenes/Other/MouseFollower.tscn");
var mouse_follower: Area2D;


func _ready() -> void:
    mouse_follower = mouse_follower_scene.instance();
    get_tree().current_scene.add_child(mouse_follower);


func _physics_process(_delta: float) -> void:
    if mouse_follower == null:
        return;

    mouse_follower.global_position = get_viewport().get_mouse_position();


func get_entities_at_mouse_position() -> Array:
    assert(mouse_follower != null, "Mouse Follower Does Not Exist");

    var entities_at_mouse_pos: Array = [];

    for body in mouse_follower.get_overlapping_bodies():
        if body is Entity:
            entities_at_mouse_pos.append(body);
        
    return entities_at_mouse_pos;