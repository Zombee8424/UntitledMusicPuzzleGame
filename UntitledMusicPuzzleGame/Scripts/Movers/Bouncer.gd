class_name Bouncer
extends Mover


export var bounce_force: float = 50;
var bounce_direction: Vector2 = Vector2.UP;
var bounce_angle: float;
var direction_display: Node2D;


func _ready() -> void:
	._ready();

	assert(has_node("MoverDirectionDisplay"), "Bouncer has no MoverDirectionDisplay child");
	direction_display = get_node("MoverDirectionDisplay");


func _on_body_entered(body: Node) -> void:
	if !body is Beater:
		return;
	
	body = body as RigidBody2D;
	body.apply_central_impulse((Vector2.UP.rotated(bounce_angle)) * bounce_force);


func flip_direction() -> void:
	bounce_direction *= -1;

	set_direction_display_angle();


func set_direction_display_angle() -> void:
	if direction_display == null:
		return;

	var angle = rotation_degrees;
	if angle > 90 and angle < 270:
		angle -= 180;

	if bounce_direction == Vector2.UP:
		pass;
	elif bounce_direction == Vector2.DOWN:
		angle -= 180;
	
	direction_display.global_rotation_degrees = angle;
	bounce_angle = angle;


func _on_mover_position_update() -> void:
	if direction_display == null:
		return;

	direction_display.global_position = get_parent().get_mover_mid_point();
	set_direction_display_angle()
