extends Node2D
	
var velocity_mps: float = -40.0 # This should be negative to move towards the player

@onready var sprite_2d : Sprite2D = $Sprite2D
var start_scale: Vector2 = Vector2(1, 1) # The scale at the bottom of the screen
var horizon_scale: Vector2 = Vector2(0, 0) # The scale at the horizon

var min_scale: float = 0.1 # The minimum scale when the obstacle reaches the horizon
var max_scale: float = 1.0 # The maximum scale when the obstacle is at the bottom

func _physics_process(delta: float) -> void:
	position.y += velocity_mps * delta
	# sprite_2d.scale *= 0.999
	# todo remove from screen
	
	var road_scene = get_parent()
	var horizon_y = road_scene.get_horizon_y_position()
	# Clamp the position to avoid going beyond the horizon or below the screen bottom
	position.y = clamp(position.y, horizon_y, road_scene.HEIGHT)
	# Calculate the scale factor based on the logarithmic scale
	# The +1 ensures we never try to take the logarithm of 0.
	var distance_ratio = (position.y - horizon_y) / (road_scene.HEIGHT - horizon_y)
	var scale_factor = log(distance_ratio * (1 / min_scale - 1) + 1) / log(1 / min_scale)

	scale = Vector2(max_scale, max_scale) * scale_factor
	
	# If the obstacle has reached the horizon, remove it from the scene
	if position.y <= horizon_y:
		queue_free()
