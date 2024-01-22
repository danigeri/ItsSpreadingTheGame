extends Node2D

var velocity_mps: float = -100.0

var min_scale: float = 0.1
var max_scale: float = 1.0

var initial_x_position: float # Store the initial X position of the obstacle

func _ready() -> void:
	initial_x_position = position.x # Set the initial X position

func _physics_process(delta: float) -> void:
	position.y += velocity_mps * delta

	var road_scene = get_parent()
	var horizon_y = road_scene.get_horizon_y_position()
	position.y = clamp(position.y, horizon_y, road_scene.HEIGHT)

	# Logarithmic scaling
	var distance_ratio = (position.y - horizon_y) / (road_scene.HEIGHT - horizon_y)
	var scale_factor = log(distance_ratio * (1 / min_scale - 1) + 1) / log(1 / min_scale)
	scale = Vector2(max_scale, max_scale) * scale_factor

	# Inverted logarithmic movement on the X axis
	var middle_x: float = road_scene.WIDTH / 2
	var x_movement_ratio = 1 - (log(distance_ratio * (1 / min_scale - 1) + 1) / log(1 / min_scale))
	position.x = lerp(float(initial_x_position), middle_x, x_movement_ratio)

	# Remove the obstacle if it reaches the horizon
	if position.y <= horizon_y:
		queue_free()


func _on_area_2d_body_entered(body):
	print("Obstacle hit something!")
	queue_free()  # Remove the obstacle
	pass # Replace with function body.
